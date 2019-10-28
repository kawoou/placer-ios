//
//  UserServiceImpl.swift
//  Service
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common
import Domain
import RxSwift

final class UserServiceImpl: UserService {

    // MARK: - Property

    var userState = BehaviorObservable<UserState>(value: .none)

    // MARK: - Private

    private let userRepository: UserRepository

    // MARK: - Public

    func login(request: LoginRequest) -> Single<User> {
        return userRepository
            .login(request: request)
            .do(onSuccess: { [weak self] user in
                self?.userState.accept(.loggedIn(user))
            }, onError: { [weak self] _ in
                self?.userState.accept(.loggedOut)
            })
            .catchError { _ in
                .error(UserServiceError.failedToLogin)
            }
    }

    func register(request: RegisterRequest) -> Single<User> {
        return userRepository
            .register(request: request)
            .flatMap { [weak self] status in
                guard let ss = self else { return .error(CommonError.nilSelf) }
                guard status else {
                    return .error(UserServiceError.failedToRegister)
                }

                let login = LoginRequest(
                    email: request.email ?? "",
                    password: request.password ?? ""
                )
                return ss.login(request: login)
                    .catchError { _ in
                        .error(UserServiceError.failedToRegister)
                    }
            }
    }

    init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }
}
