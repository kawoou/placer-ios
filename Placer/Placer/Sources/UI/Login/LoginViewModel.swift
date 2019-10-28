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
        userService: UserService,
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
            .share(replay: 1, scope: .forever)

        inputStream
            .map { $0.isValid() }
            .bind(to: output.isSubmitActive)
            .disposed(by: disposeBag)

        input.submit
            .withLatestFrom(inputStream)
            .filter { $0.isValid() }
            .flatMapLatest {
                userService.login(request: $0)
                    .asObservable()
                    .catchError { _ in
                        coordinator <- AppCoordinator.Action.showAlert(title: "로그인", message: "이메일 혹은 비밀번호가 잘못되었습니다!")
                        return .empty()
                    }
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                coordinator <- AppCoordinator.Action.presentMain
            })
            .disposed(by: disposeBag)

        input.register
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { () in
                coordinator <- LoginCoordinator.Action.presentRegister
            })
            .disposed(by: disposeBag)
    }
}
