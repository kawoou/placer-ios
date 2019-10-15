//
//  LoginViewModel.swift
//  Placer
//
//  Created by Kawoou on 24/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common
import Service
import RxSwift
import RxRelay

final class LoginViewModel: ViewModel {

    // MARK: - ViewModel

    struct Input {
        private(set) var email = BehaviorObservable(value: "")
        private(set) var password = BehaviorObservable(value: "")
        let submit = PublishRelay<Void>()
        let register = PublishRelay<Void>()
    }
    struct Output {
        let isSubmitActive = BehaviorRelay(value: false)
        let isLoggedIn = BehaviorRelay(value: false)
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

        let inputStream = Observable
            .combineLatest(
                input.email,
                input.password
            ) { LoginRequest(email: $0, password: $1) }
            .filter { $0.isValid() }
            .share(replay: 1, scope: .forever)

        inputStream
            .map { $0.isValid() }
            .bind(to: output.isSubmitActive)
            .disposed(by: disposeBag)

        input.submit
            .withLatestFrom(inputStream)
            .map { String(data: try JSONEncoder().encode($0), encoding: .utf8)! }
            .debug()
            .subscribe()
            .disposed(by: disposeBag)

        input.register
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { () in
                coordinator <- LoginCoordinator.Action.presentRegister
            })
            .disposed(by: disposeBag)
    }
}
