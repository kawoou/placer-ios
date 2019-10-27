//
//  MainCoordinator.swift
//  Placer
//
//  Created by Kawoou on 26/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {

    enum Action {
        case presentMap

        case popOne
        case pushPlace(Int)
    }

    func instantiate() -> MainNavigationController {
        container.resolve(MainNavigationController.self)!
    }
    func coordinate(_ action: Action) -> [CoordinatorAction<MainNavigationController>] {
        switch action {
        case .presentMap:
            return [
                .popToRoot(),
                .push(container.resolve(MapCoordinator.self)!)
            ]

        case .popOne:
            return [.pop()]

        case let .pushPlace(id):
            return [.push(container.resolve(PlaceCoordinator.self, argument: id)!)]
        }
    }
}
