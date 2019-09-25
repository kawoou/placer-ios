//
//  RegisterCoordinator.swift
//  Placer
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import UIKit

final class RegisterCoordinator: Coordinator {
    enum Action {
        case dismiss
    }

    func instanciate() -> RegisterViewController {
        return container.resolve(RegisterViewController.self)!
    }

    func coordinate(_ action: Action) -> [CoordinatorAction<RegisterViewController>] {
        switch action {
        case .dismiss:
            return [.dismiss()]
        }
    }
}
