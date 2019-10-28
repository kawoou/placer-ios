//
//  RegisterViewModel.swift
//  Placer
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common
import Service
import RxSwift
import RxRelay

final class RegisterViewModel: ViewModel {

    // MARK: - ViewModel

    struct Input {
        private(set) var nickname = BehaviorObservable(value: "")
        private(set) var email = BehaviorObservable(value: "")
        private(set) var password1 = BehaviorObservable(value: "")
        private(set) var password2 = BehaviorObservable(value: "")
        let submit = PublishRelay<Void>()
        let close = PublishRelay<Void>()
    }
    struct Output {
        let isSubmitActive = BehaviorRelay(value: false)
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
                input.nickname,
                input.email,
                Observable
                    .combineLatest(
                        input.password1,
                        input.password2
                    )
                    .filter { $0.0 == $0.1 }
                    .map { $0.0 }
            ) { RegisterRequest(nickname: $0, email: $1, password: $2) }
            .share(replay: 1, scope: .forever)

        inputStream
            .map { $0.isValid() }
            .bind(to: output.isSubmitActive)
            .disposed(by: disposeBag)

        input.submit
            .withLatestFrom(inputStream)
            .filter { $0.isValid() }
            .flatMapLatest {
                userService.register(request: $0)
                    .asObservable()
                    .catchError { _ in
                        coordinator <- AppCoordinator.Action.showAlert(title: "회원가입", message: "회원가입에 실패했습니다!")
                        return .empty()
                    }
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                coordinator <- RegisterCoordinator.Action.dismiss
            })
            .disposed(by: disposeBag)

        input.close
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { () in
                coordinator <- RegisterCoordinator.Action.dismiss
            })
            .disposed(by: disposeBag)
    }

}
