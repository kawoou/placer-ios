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
        case presentMap
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
                .present(container.resolve(SplashCoordinator.self)!)
            ]

        case .presentLogin:
            return [
                .present(container.resolve(LoginCoordinator.self)!)
            ]

        case .presentMap:
            return [
                .present(container.resolve(PlaceCoordinator.self)!)
//                .present(container.resolve(MapCoordinator.self)!)
            ]
        }
    }

    required init() {}
}
