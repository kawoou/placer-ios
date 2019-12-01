//
//  MainCoordinator.swift
//  Placer
//
//  Created by Kawoou on 26/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit
import Domain

final class MainCoordinator: Coordinator {

    enum Action {
        case presentMap

        case popOne
        case pushPlace(
            cityName: String,
            longitude: Double,
            latitude: Double,
            zoom: Double
        )
        case pushPostDetail(post: Post)
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

        case let .pushPlace(cityName, longitude, latitude, zoom):
            return [
                .push(container.resolve(PlaceCoordinator.self, arguments: cityName, longitude, latitude, zoom)!)
            ]

        case let .pushPostDetail(post):
            return [
                .push(container.resolve(PostDetailCoordinator.self, argument: post)!)
            ]
        }
    }
}
