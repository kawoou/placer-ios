//
//  Dependency.swift
//  Domain
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Network
import Swinject

public let container = Container(parent: Network.container) { container in
    container.register(UserRepository.self) { (resolver, provider) in
        return UserRepositoryImpl(provider: provider)
    }
}
