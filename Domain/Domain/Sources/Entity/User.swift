//
//  User.swift
//  Domain
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case email = "mail"
        case nickname
    }

    public let id: Int
    public let email: String
    public let nickname: String
}
