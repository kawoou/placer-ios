//
//  RegisterRequest.swift
//  Common
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public struct RegisterRequest: Encodable, Validable {

    // MARK: - Property

    public var target: [Validable] {
        return [_nickname, _email, _password]
    }

    @Valid(.limitLength(min: 2))
    public var nickname: String

    @Valid(.email)
    public var email: String

    @Valid(.limitLength(min: 6))
    public var password: String

    // MARK: - Lifecycle

    public init(
        nickname: String,
        email: String,
        password: String
    ) {
        self.nickname = nickname
        self.email = email
        self.password = password
    }
}
