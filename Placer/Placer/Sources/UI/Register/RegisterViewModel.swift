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
    }
    struct Output {
        let isSubmitActive = BehaviorRelay(value: false)
    }

    // MARK: - Property

    let input: Input
    let output: Output

    // MARK: - Private

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.input = input
        self.output = output

        let inputStream = Observable
            .combineLatest(
                input.nickname,
                input.email,
                input.password1,
                input.password2
            ) { RegisterRequest(nickname: $0, email: $1, password1: $2, password2: $3) }
            .share(replay: 1, scope: .forever)

        inputStream
            .map { $0.isValid() }
            .bind(to: output.isSubmitActive)
            .disposed(by: disposeBag)
    }

}
