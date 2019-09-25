//
//  SplashViewModel.swift
//  Placer
//
//  Created by Kawoou on 22/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Service
import RxSwift
import RxRelay

final class SplashViewModel: ViewModel {

    // MARK: - ViewModel

    struct Input {
        let initial = PublishRelay<Void>()
    }
    struct Output {
        let isLoading = BehaviorRelay<Bool>(value: true)
    }

    // MARK: - Property

    let coordinator: CoordinatorPerformable
    let input: Input
    let output: Output

    // MARK: - Private

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        coordinator: CoordinatorPerformable,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.coordinator = coordinator
        self.input = input
        self.output = output

        Observable.just(Void())
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { () in
                coordinator <- AppCoordinator.Action.presentLogin
            })
            .disposed(by: disposeBag)
    }
}
