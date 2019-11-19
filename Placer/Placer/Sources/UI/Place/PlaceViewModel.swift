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
        let setTab = PublishRelay<TabType>()
        let back = PublishRelay<Void>()
    }
    struct Output {
        let sections = BehaviorRelay<[PlaceSection]>(value: [])
        let tab = BehaviorRelay<TabType>(value: .newest)
    }

    // MARK: - Property

    let coordinator: CoordinatorPerformable
    let input: Input
    let output: Output

    // MARK: - Private

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        placeId: Int,
        postService: PostService,
        coordinator: CoordinatorPerformable,
        input: Input = .init(),
        output: Output = .init()
    ) {
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

        output.tab
            .flatMapLatest { tab -> Single<[Post]> in
                switch tab {
                case .newest:
                    return postService.getPostsByNewest(page: 0, latitude: 37.302101, longitude: 126.57634, zoom: 10000)
                case .popular:
                    return postService.getPostsByPopular(page: 0, latitude: 37.302101, longitude: 126.57634, zoom: 10000)
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
