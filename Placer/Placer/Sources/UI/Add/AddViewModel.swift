//
//  AddViewModel.swift
//  Placer
//
//  Created by Kawoou on 11/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common
import RxSwift

final class AddViewModel: ViewModel {

    // MARK: - Dependency

    private let coordinator: CoordinatorPerformable

    // MARK: - ViewModel

    struct Input {

    }
    struct Output {

    }

    // MARK: - Property

    let input: Input
    let output: Output

    // MARK: - Lifecycle

    init(
        coordinator: CoordinatorPerformable,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.coordinator = coordinator
        self.input = input
        self.output = output
    }
    deinit {
        logger.debug("deinit: AddViewModel")
    }
}
