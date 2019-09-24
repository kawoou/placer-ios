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
    }
}
