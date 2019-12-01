//
//  Dependency.swift
//  Domain
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Network
import Alamofire
import Swinject
import Moya

public let container = Container(parent: Network.container) { container in
    container.register(SessionManager.self) { _ in
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 40
        configuration.timeoutIntervalForResource = 40
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return SessionManager(configuration: configuration)
    }

    container.register(MoyaProvider<UserAPI>.self) { resolver in
        let sessionManager = resolver.resolve(SessionManager.self)!
        return MoyaProvider<UserAPI>(manager: sessionManager)
    }

    container.register(MoyaProvider<PostAPI>.self) { resolver in
        let sessionManager = resolver.resolve(SessionManager.self)!
        return MoyaProvider<PostAPI>(manager: sessionManager)
    }

    container.register(UserRepository.self) { resolver in
        let provider = resolver.resolve(MoyaProvider<UserAPI>.self)!
        return UserRepositoryImpl(provider: provider)
    }

    container.register(PostRepository.self) { resolver in
        let provider = resolver.resolve(MoyaProvider<PostAPI>.self)!
        return PostRepositoryImpl(provider: provider)
    }
}
