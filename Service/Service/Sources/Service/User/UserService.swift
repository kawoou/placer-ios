//
//  UserService.swift
//  Service
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common
import Domain
import RxSwift

public protocol UserService {
    var userState: BehaviorObservable<UserState> { get }

    func login(request: LoginRequest) -> Single<User>
    func register(request: RegisterRequest) -> Single<User>
}
