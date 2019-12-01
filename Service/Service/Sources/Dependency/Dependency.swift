//
//  Dependency.swift
//  Service
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Domain
import Swinject

public let container = Container(parent: Domain.container, defaultObjectScope: .container) { container in
    container.register(UserService.self) { resolver in
        let userRepository = resolver.resolve(UserRepository.self)!
        return UserServiceImpl(userRepository: userRepository)
    }
    container.register(LocationService.self) { _ in
        return LocationServiceImpl()
    }
    container.register(PostService.self) { resolver in
        let postRepository = resolver.resolve(PostRepository.self)!
        let userService = resolver.resolve(UserService.self)!
        let photoService = resolver.resolve(PhotoService.self)!
        return PostServiceImpl(
            postRepository: postRepository,
            userService: userService
        )
    }
    container.register(PhotoService.self) { _ in
        return PhotoServiceImpl()
    }
}
