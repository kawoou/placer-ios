//
//  RegisterRequest.swift
//  Common
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public struct RegisterRequest: Encodable {

    // MARK: - Enumerable

    enum CodingKeys: String, CodingKey {
        case nickname
        case email
        case password1
        case password2
    }

    // MARK: - Property

    @Valid(.limitLength(min: 2))
    public var nickname: String

    @Valid(.email)
    public var email: String

    @Valid(.limitLength(min: 6))
    public var password1: String

    @Valid(.limitLength(min: 6))
    public var password2: String

    // MARK: - Public

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(nickname, forKey: .nickname)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(password1, forKey: .password1)
        try container.encodeIfPresent(password2, forKey: .password2)
    }

    public func isValid() -> Bool {
        guard _nickname.isValid() else { return false }
        guard _email.isValid() else { return false }
        guard _password1.isValid() else { return false }
        guard _password2.isValid() else { return false }
        guard password1 == password2 else { return false }
        return true
    }

    // MARK: - Lifecycle

    public init(
        nickname: String,
        email: String,
        password1: String,
        password2: String
    ) {
        self.nickname = nickname
        self.email = email
        self.password1 = password1
        self.password2 = password2
    }
}
