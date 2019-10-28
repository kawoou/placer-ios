//
//  UserRepository.swift
//  Domain
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common
import RxSwift

public protocol UserRepository {
    func login(request: LoginRequest) -> Single<User>
    func register(request: RegisterRequest) -> Single<Bool>
}
