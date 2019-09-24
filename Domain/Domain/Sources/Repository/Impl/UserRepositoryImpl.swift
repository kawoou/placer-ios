//
//  UserRepositoryImpl.swift
//  Domain
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common
import Network
import RxSwift
import Moya

final class UserRepositoryImpl: UserRepository {

    // MARK: - Private

    private let provider: MoyaProvider<PlacerAPI>

    // MARK: - Public

    func login(request: LoginRequest) -> Single<User> {
        return provider.rx.request(.login(request))
            .map(LoginResponse.self)
            .map { $0.toUser() }
    }

    init(provider: MoyaProvider<PlacerAPI>) {
        self.provider = provider
    }
}

private extension LoginResponse {
    func toUser() -> User {
        return User(
            id: id,
            email: email,
            nickname: nickname,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
