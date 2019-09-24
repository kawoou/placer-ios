//
//  User.swift
//  Domain
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public struct User: Codable {
    public let id: Int
    public let email: String
    public let nickname: String
    public let createdAt: Date
    public let updatedAt: Date
}
