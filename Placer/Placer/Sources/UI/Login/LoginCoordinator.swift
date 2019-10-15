//
//  LoginCoordinator.swift
//  Placer
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

final class LoginCoordinator: Coordinator {
    enum Action {
        case presentRegister
    }

    func instantiate() -> LoginViewController {
        return container.resolve(LoginViewController.self)!
    }
    func coordinate(_ action: Action) -> [CoordinatorAction<LoginViewController>] {
        switch action {
        case .presentRegister:
            return [
                .present(container.resolve(RegisterCoordinator.self)!)
            ]
        }
    }
}
