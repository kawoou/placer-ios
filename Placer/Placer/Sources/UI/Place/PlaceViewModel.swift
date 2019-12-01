//
//  PlaceViewModel.swift
//  Placer
//
//  Created by Kawoou on 07/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Domain
import Service
import RxSwift
import RxRelay

final class PlaceViewModel: ViewModel {

    // MARK: - Enumerable

    enum TabType {
        case newest
        case popular
    }

    // MARK: - Dependency

    private let postService: PostService

    // MARK: - ViewModel

    struct Input {
        let reload = PublishRelay<Void>()

        let setTab = PublishRelay<TabType>()
        let back = PublishRelay<Void>()

        let toggleLike = PublishRelay<Post>()

        let presentDetail = PublishRelay<Post>()
    }
    struct Output {
        let sections = BehaviorRelay<[PlaceSection]>(value: [])
        let tab = BehaviorRelay<TabType>(value: .newest)
    }

    // MARK: - Property

    let cityName: String
    let longitude: Double
    let latitude: Double
    let zoom: Double

    let coordinator: CoordinatorPerformable
    let input: Input
    let output: Output

    // MARK: - Private

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        cityName: String,
        longitude: Double,
        latitude: Double,
        zoom: Double,
        postService: PostService,
        coordinator: CoordinatorPerformable,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.cityName = cityName
        self.longitude = longitude
        self.latitude = latitude
        self.zoom = zoom

        self.postService = postService
        self.coordinator = coordinator
        self.input = input
        self.output = output

        input.setTab
            .bind(to: output.tab)
            .disposed(by: disposeBag)

        input.back
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { () in
                coordinator <- MainCoordinator.Action.popOne
            })
            .disposed(by: disposeBag)

        input.presentDetail
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { post in
                coordinator <- MainCoordinator.Action.pushPostDetail(post: post)
            })
            .disposed(by: disposeBag)

        Observable
            .merge(
                output.tab.asObservable(),
                input.reload.withLatestFrom(output.tab),
                input.toggleLike
                    .flatMapLatest { post -> Observable<Bool> in
                        postService.toggleLikePost(postId: post.id)
                            .asObservable()
                            .catchError { _ in .empty() }
                    }
                    .withLatestFrom(output.tab)
            )
            .flatMapLatest { tab -> Single<[Post]> in
                switch tab {
                case .newest:
                    return postService.getPostsByNewest(page: 1, latitude: latitude, longitude: longitude, zoom: zoom)
                        .catchErrorJustReturn([])
                case .popular:
                    return postService.getPostsByPopular(page: 1, latitude: latitude, longitude: longitude, zoom: zoom)
                        .catchErrorJustReturn([])
                }
            }
            .map { list -> [PlaceSection] in
                let sections = list.map { post -> PlaceSection in
                    let viewModel = PostCellModel(post: post)
                    return .items([
                        .user(viewModel),
                        .image(viewModel),
                        .action(viewModel),
                        .content(viewModel)
                    ])
                }
                return sections
            }
            .asObservable()
            .bind(to: output.sections)
            .disposed(by: disposeBag)
    }
}
