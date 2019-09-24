//
//  DomainDependency.swift
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

//public final class DomainDependency {
//
//    // MARK: - Dependency
//
//    let network: NetworkDependency
//
//    public let user: UserRepository
//
//    // MARK: - Lifecycle
//
//    public init(
//        network: NetworkDependency? = nil,
//        user: UserRepository? = nil
//    ) {
//        let network = network ?? NetworkDependency()
//        self.network = network
//        self.user = user ?? UserRepositoryImpl(network: network)
//    }
//}
