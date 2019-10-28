//
//  LoginRequest.swift
//  Network
//
//  Created by Kawoou on 14/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public struct LoginRequest: Encodable, Validable {

    enum CodingKeys: String, CodingKey {
        case email = "mail"
        case password
    }

    // MARK: - Property

    public var target: [Validable] {
        return [_email, _password]
    }

    @Valid(.email)
    public var email: String

    @Valid(.limitLength(min: 6))
    public var password: String

    // MARK: - Lifecycle

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
