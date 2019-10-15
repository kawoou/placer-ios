//
//  AddCoordinator.swift
//  Placer
//
//  Created by Kawoou on 11/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import Common

final class AddCoordinator: Coordinator {

    enum Action {

    }

    func instantiate() -> UINavigationController {
        let viewController = container.resolve(AddViewController.self)!
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }

    func coordinate(_ action: Action) -> [CoordinatorAction<UINavigationController>] {

    }
    deinit {
        logger.debug("deinit: AddCoordinator")
    }
}
