//
//  NetworkDependency.swift
//  Network
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Moya
import Swinject

public let container = Container { container in
    container.register(MoyaProvider<PlacerAPI>.self) { resolver in
        return MoyaProvider<PlacerAPI>()
    }
}

//public final class NetworkDependency {
//
//    // MARK: - Dependency
//
//    public let placer: MoyaProvider<PlacerAPI>
//
//    // MARK: - Lifecycle
//
//    public init(
//        provider: MoyaProvider<PlacerAPI>? = nil
//    ) {
//        self.placer = provider ?? MoyaProvider<PlacerAPI>()
//    }
//}
