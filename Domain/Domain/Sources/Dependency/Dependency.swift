//
//  Dependency.swift
//  Domain
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Network
import Swinject
import Moya

public let container = Container(parent: Network.container) { container in
    container.register(MoyaProvider<UserAPI>.self) { _ in
        return MoyaProvider<UserAPI>()
    }

    container.register(MoyaProvider<PostAPI>.self) { _ in
        return MoyaProvider<PostAPI>()
    }

    container.register(UserRepository.self) { resolver in
        let provider = resolver.resolve(MoyaProvider<UserAPI>.self)!
        return UserRepositoryImpl(provider: provider)
    }
}
