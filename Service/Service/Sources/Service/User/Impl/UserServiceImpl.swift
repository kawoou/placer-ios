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

    // MARK: - Constant

    private struct Constant {
        static let loginUserDefaultsKey = "login"
    }

    // MARK: - Property

    var userState = BehaviorObservable<UserState>(value: .none)

    // MARK: - Private

    private let userRepository: UserRepository

    private func loadLoginInfo() -> LoginRequest? {
        guard let data = UserDefaults.standard.data(forKey: Constant.loginUserDefaultsKey) else { return nil }
        return try? JSONDecoder().decode(LoginRequest.self, from: data)
    }
    private func saveLoginInfo(_ request: LoginRequest) {
        guard let data = try? JSONEncoder().encode(request) else { return }
        UserDefaults.standard.set(data, forKey: Constant.loginUserDefaultsKey)
    }
    private func deleteLoginInfo() {
        UserDefaults.standard.removeObject(forKey: Constant.loginUserDefaultsKey)
    }

    // MARK: - Public

    func loginIfNeeded() -> Single<User?> {
        guard case .none = userState.value else { return .just(nil) }
        guard let loginRequest = loadLoginInfo() else { return .just(nil) }
        return login(request: loginRequest).map { $0 }
    }

    func login(request: LoginRequest) -> Single<User> {
        return userRepository
            .login(request: request)
            .do(onSuccess: { [weak self] user in
                self?.saveLoginInfo(request)
                self?.userState.accept(.loggedIn(user))
            }, onError: { [weak self] _ in
                self?.userState.accept(.loggedOut)
            })
            .catchError { _ in
                .error(UserServiceError.failedToLogin)
            }
    }

    func logout() -> Single<Void> {
        deleteLoginInfo()
        userState.accept(.loggedOut)
        return .just(Void())
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
