//
//  Dependency.swift
//  Placer
//
//  Created by Kawoou on 22/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Photos
import Domain
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
            let userService = resolver.resolve(UserService.self)!
            let coordinator = resolver.resolve(SplashCoordinator.self)!
            return SplashViewModel(
                userService: userService,
                coordinator: coordinator
            )
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
            let userService = resolver.resolve(UserService.self)!
            let coordinator = resolver.resolve(LoginCoordinator.self)!
            return LoginViewModel(
                userService: userService,
                coordinator: coordinator
            )
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
            let userService = resolver.resolve(UserService.self)!
            let coordinator = resolver.resolve(RegisterCoordinator.self)!
            return RegisterViewModel(
                userService: userService,
                coordinator: coordinator
            )
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
            let postService = resolver.resolve(PostService.self)!
            let coordinator = resolver.resolve(MapCoordinator.self)!
            return MainViewModel(
                locationService: locationService,
                postService: postService,
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
        .register(PlaceCoordinator.self) { (_, cityName: String, longitude: Double, latitude: Double, zoom: Double) in
            return PlaceCoordinator(
                cityName: cityName,
                longitude: longitude,
                latitude: latitude,
                zoom: zoom
            )
        }
        .inObjectScope(.weak)

    container
        .register(PlaceViewModel.self) { (resolver, cityName: String, longitude: Double, latitude: Double, zoom: Double) in
            let postService = resolver.resolve(PostService.self)!
            let coordinator = resolver.resolve(PlaceCoordinator.self, arguments: cityName, longitude, latitude, zoom)!
            return PlaceViewModel(
                cityName: cityName,
                longitude: longitude,
                latitude: latitude,
                zoom: zoom,
                postService: postService,
                coordinator: coordinator
            )
        }
        .inObjectScope(.weak)

    container
        .register(PlaceViewController.self) { (resolver, cityName: String, longitude: Double, latitude: Double, zoom: Double) in
            let viewModel = resolver.resolve(PlaceViewModel.self, arguments: cityName, longitude, latitude, zoom)!
            return PlaceViewController(viewModel: viewModel)
        }
        .inObjectScope(.weak)

    /// Post Detail
    container
        .register(PostDetailCoordinator.self) { (_, post: Post) in
            return PostDetailCoordinator(post: post)
        }
        .inObjectScope(.weak)

    container
        .register(PostDetailViewModel.self) { (resolver, post: Post) in
            let postService = resolver.resolve(PostService.self)!
            return PostDetailViewModel(post: post, postService: postService)
        }
        .inObjectScope(.weak)

    container
        .register(PostDetailViewController.self) { (resolver, post: Post) in
            let viewModel = resolver.resolve(PostDetailViewModel.self, argument: post)!
            return PostDetailViewController(
                viewModel: viewModel
            )
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
            let postService = resolver.resolve(PostService.self)!
            let photoService = resolver.resolve(PhotoService.self)!
            let coordinator = resolver.resolve(AddCoordinator.self)!
            return AddViewModel(
                postService: postService,
                photoService: photoService,
                coordinator: coordinator
            )
        }
        .inObjectScope(.weak)

    container
        .register(AddViewController.self) { resolver in
            let viewModel = resolver.resolve(AddViewModel.self)!
            return AddViewController(viewModel: viewModel)
        }
        .inObjectScope(.weak)

    /// Upload
    container
        .register(UploadViewModel.self) { (resolver, photo: PHAsset, photoExif: PhotoExif, description: String) in
            let postService = resolver.resolve(PostService.self)!
            let photoService = resolver.resolve(PhotoService.self)!
            let coordinator = resolver.resolve(AddCoordinator.self)!

            return UploadViewModel(
                uploadPhoto: photo,
                photoExif: photoExif,
                description: description,
                postService: postService,
                photoService: photoService,
                coordinator: coordinator
            )
        }
        .inObjectScope(.weak)

    container
        .register(UploadViewController.self) { (_, viewModel: UploadViewModel) in
            return UploadViewController(
                viewModel: viewModel
            )
        }
        .inObjectScope(.weak)
}
