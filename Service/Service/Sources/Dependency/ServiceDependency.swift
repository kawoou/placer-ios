//
//  ServiceDependency.swift
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

//public final class ServiceDependency {
//
//    // MARK: - Dependency
//
//    let domain: DomainDependency
//
//    public let user: UserService
//
//    // MARK: - Lifecycle
//
//    public init(
//        domain: DomainDependency? = nil,
//        user: UserService? = nil
//    ) {
//        let domain = domain ?? DomainDependency()
//        self.domain = domain
//        self.user = user ?? UserServiceImpl(domain: domain)
//    }
//}
