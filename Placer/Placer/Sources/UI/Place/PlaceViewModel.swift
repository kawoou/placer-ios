//
//  PlaceViewModel.swift
//  Placer
//
//  Created by Kawoou on 07/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

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

    private let placeService: PlaceService

    // MARK: - ViewModel

    struct Input {
        let setTab = PublishRelay<TabType>()
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
        placeService: PlaceService,
        coordinator: CoordinatorPerformable,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.placeService = placeService
        self.coordinator = coordinator
        self.input = input
        self.output = output

        input.setTab
            .bind(to: output.tab)
            .disposed(by: disposeBag)

        output.tab
            .flatMapLatest { _ in
                placeService.getPost(placeId: placeId)
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
