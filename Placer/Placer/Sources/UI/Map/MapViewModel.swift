//
//  MapViewModel.swift
//  Placer
//
//  Created by Kawoou on 06/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import MapKit
import Service
import RxSwift
import RxRelay

final class MainViewModel: ViewModel {

    // MARK: - Dependency

    let locationService: LocationService

    // MARK: - ViewModel

    struct Input {
        let searchQuery = PublishRelay<String>()
        let add = PublishRelay<Void>()
        let setCurrentLocation = PublishRelay<Bool>()
    }
    struct Output {
        let searchQuery = BehaviorRelay<String>(value: "")
        let searchResult = BehaviorRelay<[MKMapItem]>(value: [])

        let isCurrentLocation = BehaviorRelay<Bool>(value: false)
        let currentLocation = BehaviorRelay<Location?>(value: nil)
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
    }
}
