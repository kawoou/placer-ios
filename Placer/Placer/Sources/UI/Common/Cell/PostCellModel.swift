//
//  PostCellModel.swift
//  Placer
//
//  Created by Kawoou on 07/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Domain
import RxSwift
import RxRelay

final class PostCellModel: ViewModel {

    // MARK: - ViewModel

    struct Input {

    }
    struct Output {

    }

    // MARK: - Property

    let post: Post

    let input: Input
    let output: Output

    // MARK: - Lifecycle

    init(
        post: Post,
        input: Input = .init(),
        output: Output = .init()
    ) {
        self.post = post

        self.input = input
        self.output = output
    }

}
