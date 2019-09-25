//
//  LoginRequest.swift
//  Network
//
//  Created by Kawoou on 14/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public struct LoginRequest: Encodable {

    // MARK: - Enumerable

    enum CodingKeys: String, CodingKey {
        case email
        case password
    }

    // MARK: - Property

    @Valid(.email)
    public var email: String

    @Valid(.limitLength(min: 6))
    public var password: String

    // MARK: - Public

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(password, forKey: .password)
    }

    public func isValid() -> Bool {
        return _email.isValid() && _password.isValid()
    }

    // MARK: - Lifecycle

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
    
