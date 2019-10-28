//
//  AppCoordinator.swift
//  Placer
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit

class AppCoordinator: WindowCoordinator {

    enum Action {
        case presentSplash
        case presentLogin
        case presentMain

        case showAlert(title: String? = nil, message: String)
    }

    func instantiate() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        return window
    }

    func coordinate(_ action: Action) -> [CoordinatorAction<UIWindow>] {
        switch action {
        case .presentSplash:
            return [
                .move(container.resolve(SplashCoordinator.self)!)
            ]

        case .presentLogin:
            return [
                .move(container.resolve(LoginCoordinator.self)!)
            ]

        case .presentMain:
            let coordinator = container.resolve(MainCoordinator.self)!
            return [
                .move(coordinator),
                .perform(coordinator, action: .presentMap)
            ]

        case let .showAlert(title: title, message: message):
            let viewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            viewController.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            return [.present(viewController)]
        }
    }

    required init() {}
}
