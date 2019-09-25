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
    container.register(UserService.self) { (resolver, userRepository) in
        return UserServiceImpl(userRepository: userRepository)
    }
}
