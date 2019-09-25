//
//  SplashCoordinator.swift
//  Placer
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

final class SplashCoordinator: Coordinator {
    enum Action {}

    func instanciate() -> SplashViewController {
        return container.resolve(SplashViewController.self)!
    }
    func coordinate(_ action: Action) -> [CoordinatorAction<SplashViewController>] {}
}
