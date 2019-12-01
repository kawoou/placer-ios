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

    private let cityName: String
    private let longitude: Double
    private let latitude: Double
    private let zoom: Double

    func instantiate() -> PlaceViewController {
        return container.resolve(PlaceViewController.self, arguments: cityName, longitude, latitude, zoom)!
    }
    func coordinate(_ action: Action) -> [CoordinatorAction<PlaceViewController>] {}

    init(cityName: String, longitude: Double, latitude: Double, zoom: Double) {
        self.cityName = cityName
        self.longitude = longitude
        self.latitude = latitude
        self.zoom = zoom
    }
    init() {
        fatalError("Cannot instantiate coordinator, placeId required")
    }
}
