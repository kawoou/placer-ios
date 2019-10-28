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
import RxOptional
import Moya

final class UserRepositoryImpl: UserRepository {

    // MARK: - Private

    private let provider: MoyaProvider<UserAPI>

    // MARK: - Public

    func login(request: LoginRequest) -> Single<User> {
        provider.rx.request(.login(request: request))
            .map(LoginResponse.self)
            .map { $0.toUser() }
    }

    func register(request: RegisterRequest) -> Single<Bool> {
        provider.rx.request(.register(request: request))
            .map(Bool.self)
    }

    init(provider: MoyaProvider<UserAPI>) {
        self.provider = provider
    }
}

private extension LoginResponse {
    func toUser() -> User {
        return User(
            id: id,
            email: email,
            nickname: nickname
        )
    }
}
