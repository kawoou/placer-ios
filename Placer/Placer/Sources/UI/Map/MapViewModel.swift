//
//  MapViewModel.swift
//  Placer
//
//  Created by Kawoou on 06/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import MapKit
import Domain
import Service
import RxSwift
import RxRelay

final class MainViewModel: ViewModel {

    typealias LocationZoom = (CLLocationCoordinate2D, Double)

    // MARK: - Dependency

    let locationService: LocationService

    // MARK: - ViewModel

    struct Input {
        let searchQuery = PublishRelay<String>()
        let add = PublishRelay<Void>()
        let setCurrentLocation = PublishRelay<Bool>()
        let selectPlace = PublishRelay<Int>()

        let moveCenterLocation = BehaviorRelay<LocationZoom?>(value: nil)
    }
    struct Output {
        let searchQuery = BehaviorRelay<String>(value: "")
        let searchResult = BehaviorRelay<[MKMapItem]>(value: [])

        let isCurrentLocation = BehaviorRelay<Bool>(value: false)
        let currentLocation = BehaviorRelay<Location?>(value: nil)

        let mapPosts = BehaviorRelay<[PostMap]>(value: [])
    }

    // MARK: - Property

    let coordinator: CoordinatorPerformable
    let input: Input
    let output: Output

    // MARK: - Private

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        locationService: LocationService,
        postService: PostService,
        coordinator: CoordinatorPerformable,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.locationService = locationService

        self.coordinator = coordinator
        self.input = input
        self.output = output

        input.searchQuery
            .bind(to: output.searchQuery)
            .disposed(by: disposeBag)

        input.searchQuery
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMap {
                locationService.searchLocation(query: $0)
                    .asObservable()
                    .catchErrorJustReturn([])
            }
            .bind(to: output.searchResult)
            .disposed(by: disposeBag)

        input.add
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { () in
                coordinator <- MapCoordinator.Action.presentAdd
            })
            .disposed(by: disposeBag)

        input.setCurrentLocation
            .bind(to: output.isCurrentLocation)
            .disposed(by: disposeBag)

        input.setCurrentLocation
            .flatMapLatest { status -> Observable<Location> in
                switch status {
                case true:
                    return locationService.observeCurrentLocation()
                case false:
                    return .empty()
                }
            }
            .map { $0 }
            .bind(to: output.currentLocation)
            .disposed(by: disposeBag)

        input.selectPlace
            .withLatestFrom(output.mapPosts) { (postId, list) in
                list.first { $0.id == postId }
            }
            .filterNil()
            .flatMapLatest { post in
                locationService.searchSimilarCityName(longitude: post.longitude, latitude: post.latitude)
                    .map { ($0, post.longitude, post.latitude) }
            }
            .withLatestFrom(input.moveCenterLocation) {
                ($0.0, $0.1, $0.2, $1?.1 ?? 10000)
            }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (cityName, longitude, latitude, zoom) in
                coordinator <- MainCoordinator.Action.pushPlace(
                    cityName: cityName,
                    longitude: longitude,
                    latitude: latitude,
                    zoom: zoom / 10
                )
            })
            .disposed(by: disposeBag)

        input.moveCenterLocation
            .filterNil()
            .flatMapLatest { (location, zoom) in
                postService.getPostsByMap(
                    latitude: location.latitude,
                    longitude: location.longitude,
                    zoom: zoom
                )
            }
            .bind(to: output.mapPosts)
            .disposed(by: disposeBag)
    }
}
