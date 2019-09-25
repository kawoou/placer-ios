//
//  MainTabBarCoordinator.swift
//  Placer
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit

final class MainTabBarCoordinator: Coordinator {
    enum Action {
        case showMap
    }

    private var mapCoordinator: MapCoordinator?

    func instanciate() -> MainTabBarController {
        let map = container.resolve(MapCoordinator.self)!

        mapCoordinator = map

        let controller = container.resolve(MainTabBarController.self)!
        controller.viewControllers = [
            map.target
        ]
        return controller
    }

    func coordinate(_ action: Action) -> [CoordinatorAction<MainTabBarController>] {
        switch action {
        case .showMap:
            return [
                .perform(mapCoordinator!, action: .popToRoot),
                .changeTab(0)
            ]
        }
    }
}
