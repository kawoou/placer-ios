//
//  Dependency.swift
//  Placer
//
//  Created by Kawoou on 22/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Service
import Swinject

public let container = Container(parent: Service.container) { container in
    /// App
    container
        .register(AppCoordinator.self) { _ in AppCoordinator() }
        .inObjectScope(.weak)

    /// Splash
    container
        .register(SplashCoordinator.self) { _ in SplashCoordinator() }
        .inObjectScope(.weak)

    container
        .register(SplashViewModel.self) { resolver in
            let coordinator = resolver.resolve(SplashCoordinator.self)!
            return SplashViewModel(coordinator: coordinator)
        }
        .inObjectScope(.weak)

    container
        .register(SplashViewController.self) { resolver in
            let viewModel = resolver.resolve(SplashViewModel.self)!
            return SplashViewController(viewModel: viewModel)
        }
        .inObjectScope(.weak)

    /// Login
    container
        .register(LoginCoordinator.self) { _ in
            return LoginCoordinator()
        }
        .inObjectScope(.weak)

    container
        .register(LoginViewModel.self) { resolver in
            let coordinator = resolver.resolve(LoginCoordinator.self)!
            return LoginViewModel(coordinator: coordinator)
        }
        .inObjectScope(.weak)

    container
        .register(LoginViewController.self) { resolver in
            let viewModel = resolver.resolve(LoginViewModel.self)!
            return LoginViewController(viewModel: viewModel)
        }
        .inObjectScope(.weak)

    /// Register
    container
        .register(RegisterCoordinator.self) { _ in
            return RegisterCoordinator()
        }
        .inObjectScope(.weak)

    container
        .register(RegisterViewModel.self) { resolver in
            let coordinator = resolver.resolve(RegisterCoordinator.self)!
            return RegisterViewModel(coordinator: coordinator)
        }
        .inObjectScope(.weak)

    container
        .register(RegisterViewController.self) { resolver in
            let viewModel = resolver.resolve(RegisterViewModel.self)!
            return RegisterViewController(viewModel: viewModel)
        }
        .inObjectScope(.weak)

    /// Main
    container
        .register(MainCoordinator.self) { _ in
            return MainCoordinator()
        }

    container
        .register(MainNavigationController.self) { _ in
            return MainNavigationController()
        }

    /// Map
    container
        .register(MapCoordinator.self) { _ in
            return MapCoordinator()
        }
        .inObjectScope(.weak)

    container
        .register(MainViewModel.self) { resolver in
            let locationService = resolver.resolve(LocationService.self)!
            let coordinator = resolver.resolve(MapCoordinator.self)!
            return MainViewModel(
                locationService: locationService,
                coordinator: coordinator
            )
        }
        .inObjectScope(.weak)

    container
        .register(MapViewController.self) { resolver in
            let viewModel = resolver.resolve(MainViewModel.self)!
            return MapViewController(viewModel: viewModel)
        }
        .inObjectScope(.weak)

    /// Place
    container
        .register(PlaceCoordinator.self) { (_, placeId) in
            return PlaceCoordinator(placeId: placeId)
        }
        .inObjectScope(.weak)

    container
        .register(PlaceViewModel.self) { (resolver, placeId: Int) in
            let placeService = resolver.resolve(PlaceService.self)!
            let coordinator = resolver.resolve(PlaceCoordinator.self, argument: placeId)!
            return PlaceViewModel(
                placeId: placeId,
                placeService: placeService,
                coordinator: coordinator
            )
        }
        .inObjectScope(.weak)

    container
        .register(PlaceViewController.self) { (resolver, placeId: Int) in
            let viewModel = resolver.resolve(PlaceViewModel.self, argument: placeId)!
            return PlaceViewController(viewModel: viewModel)
        }
        .inObjectScope(.weak)

    /// Add
    container
        .register(AddCoordinator.self) { _ in
            return AddCoordinator()
        }
        .inObjectScope(.weak)

    container
        .register(AddViewModel.self) { resolver in
            let coordinator = resolver.resolve(AddCoordinator.self)!
            return AddViewModel(coordinator: coordinator)
        }
        .inObjectScope(.weak)

    container
        .register(AddViewController.self) { resolver in
            let viewModel = resolver.resolve(AddViewModel.self)!
            return AddViewController(viewModel: viewModel)
        }
        .inObjectScope(.weak)
}
