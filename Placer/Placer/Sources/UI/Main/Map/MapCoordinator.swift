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
    }

    func instanciate() -> MapViewController {
        return container.resolve(MapViewController.self)!
    }

    func coordinate(_ action: Action) -> [CoordinatorAction<MapViewController>] {
        switch action {
        case .popToRoot:
            return [.popToRoot(animated: false)]
        }
    }
}
