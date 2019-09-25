//
//  Dependency.swift
//  Placer
//
//  Created by Kawoou on 22/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Service
import Swinject

public let container = Container(
    parent: Service.container,
    defaultObjectScope: .weak
) { container in
    /// App
    container.register(AppCoordinator.self) { _ in
        return AppCoordinator()
    }

    /// Splash
    container.register(SplashCoordinator.self) { _ in
        return SplashCoordinator()
    }
    container.register(SplashViewModel.self) { resolver in
        let coordinator = resolver.resolve(SplashCoordinator.self)!
        return SplashViewModel(coordinator: coordinator)
    }
    container.register(SplashViewController.self) { resolver in
        let viewModel = resolver.resolve(SplashViewModel.self)!
        return SplashViewController(viewModel: viewModel)
    }

    /// Login
    container.register(LoginCoordinator.self) { _ in
        return LoginCoordinator()
    }
    container.register(LoginViewModel.self) { resolver in
        let coordinator = resolver.resolve(LoginCoordinator.self)!
        return LoginViewModel(coordinator: coordinator)
    }
    container.register(LoginViewController.self) { resolver in
        let viewModel = resolver.resolve(LoginViewModel.self)!
        return LoginViewController(viewModel: viewModel)
    }

    /// Register
    container.register(RegisterCoordinator.self) { _ in
        return RegisterCoordinator()
    }
    container.register(RegisterViewModel.self) { resolver in
        let coordinator = resolver.resolve(RegisterCoordinator.self)!
        return RegisterViewModel(coordinator: coordinator)
    }
    container.register(RegisterViewController.self) { resolver in
        let viewModel = resolver.resolve(RegisterViewModel.self)!
        return RegisterViewController(viewModel: viewModel)
    }

    /// Main
    container.register(MainTabBarCoordinator.self) { _ in
        return MainTabBarCoordinator()
    }
    container.register(MainTabBarController.self) { _ in
        return MainTabBarController()
    }

    /// Map
    container.register(MapCoordinator.self) { _ in
        return MapCoordinator()
    }
    container.register(MapViewController.self) { _ in
        return MapViewController()
    }
}
