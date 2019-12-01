//
//  PostDetailCoordinator.swift
//  Placer
//
//  Created by Kawoou on 30/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import Domain

final class PostDetailCoordinator: Coordinator {
    enum Action {}

    private let post: Post

    func instantiate() -> PostDetailViewController {
        return container.resolve(PostDetailViewController.self, argument: post)!
    }
    func coordinate(_ action: Action) -> [CoordinatorAction<PostDetailViewController>] {}

    init(post: Post) {
        self.post = post
    }
    init() {
        fatalError("Cannot instantiate coordinator, postId required")
    }
}
