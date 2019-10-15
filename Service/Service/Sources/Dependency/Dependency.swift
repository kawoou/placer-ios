//
//  Dependency.swift
//  Service
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Domain
import Swinject

public let container = Container(parent: Domain.container) { container in
    container.register(UserService.self) { resolver in
        let userRepository = resolver.resolve(UserRepository.self)!
        return UserServiceImpl(userRepository: userRepository)
    }
    container.register(LocationService.self) { _ in
        return LocationServiceImpl()
    }
    container.register(PlaceService.self) { _ in
        return SamplePlaceServiceImpl()
    }
}
