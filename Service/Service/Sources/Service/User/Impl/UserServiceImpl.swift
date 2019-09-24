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

    func login(email: String, password: String) -> Single<User> {
        return userRepository
            .login(request: LoginRequest(email: email, password: password))
            .do(onSuccess: { [weak self] user in
                self?.userState.accept(.loggedIn(user))
            }, onError: { [weak self] _ in
                self?.userState.accept(.loggedOut)
            })
    }

    init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }
}
