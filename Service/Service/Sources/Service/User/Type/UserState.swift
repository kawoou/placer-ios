//
//  UserState.swift
//  Service
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Domain

public enum UserState {
    case none
    case loggedIn(User)
    case loggedOut
}
