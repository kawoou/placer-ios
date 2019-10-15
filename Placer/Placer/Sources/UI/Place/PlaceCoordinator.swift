//
//  PlaceCoordinator.swift
//  Placer
//
//  Created by Kawoou on 07/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit

final class PlaceCoordinator: Coordinator {
    enum Action {}

    private let placeId: Int

    func instantiate() -> PlaceViewController {
        return container.resolve(PlaceViewController.self, argument: placeId)!
    }
    func coordinate(_ action: Action) -> [CoordinatorAction<PlaceViewController>] {}

    init(placeId: Int) {
        self.placeId = placeId
    }
    init() {
        fatalError("Cannot instantiate coordinator, placeId required")
    }
}
