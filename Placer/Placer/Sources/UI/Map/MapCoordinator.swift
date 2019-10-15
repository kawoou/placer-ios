//
//  MapCoordinator.swift
//  Placer
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit

final class MapCoordinator: Coordinator {
    enum Action {
        case popToRoot
        case presentAdd
        case pushPlace(Int)
    }

    func instantiate() -> MapViewController {
        return container.resolve(MapViewController.self)!
    }

    func coordinate(_ action: Action) -> [CoordinatorAction<MapViewController>] {
        switch action {
        case .popToRoot:
            return [.popToRoot(animated: false)]

        case .presentAdd:
            return [.present(container.resolve(AddCoordinator.self)!)]

        case let .pushPlace(id):
            return [.push(container.resolve(PlaceCoordinator.self, argument: id)!)]
        }
    }
}
