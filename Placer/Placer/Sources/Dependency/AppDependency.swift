//
//  AppDependency.swift
//  Placer
//
//  Created by Kawoou on 22/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Service
import Swinject

public let container = Container(parent: Service.container, defaultObjectScope: .weak) { container in
    container.register(UIWindow.self, name: "main") { resolver in
        let viewController = resolver.resolve(SplashViewController.self)!

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        return window
    }

    container.register(SplashViewModel.self) { _ in
        return SplashViewModel()
    }
    container.register(SplashViewController.self) { resolver in
        let viewModel = resolver.resolve(SplashViewModel.self)!
        return SplashViewController(viewModel: viewModel)
    }

    container.register(LoginViewModel.self) { _ in
        return LoginViewModel()
    }
    container.register(LoginViewController.self) { resolver in
        let viewModel = resolver.resolve(LoginViewModel.self)!
        return LoginViewController(viewModel: viewModel)
    }

    container.register(RegisterViewModel.self) { _ in
        return RegisterViewModel()
    }
    container.register(RegisterViewController.self) { resolver in
        let viewModel = resolver.resolve(RegisterViewModel.self)!
        return RegisterViewController(viewModel: viewModel)
    }
}
