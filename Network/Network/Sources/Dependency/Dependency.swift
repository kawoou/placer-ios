//
//  Dependency.swift
//  Network
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Moya
import Swinject

public let container = Container { container in
    container.register(MoyaProvider<UserAPI>.self) { resolver in
        return MoyaProvider<UserAPI>()
    }
    container.register(MoyaProvider<PostAPI>.self) { resolver in
        return MoyaProvider<PostAPI>()

    }
}
