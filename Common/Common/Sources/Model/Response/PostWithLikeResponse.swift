//
//  PostWithLikeResponse.swift
//  Common
//
//  Created by Kawoou on 19/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public struct PostWithLikeResponse: Decodable {
    public let id: Int
    public let writerNickName: String
    public let address: String
    public let like: Int
    public let createdAt: Int
    public let comment: String?
    public let myLike: Bool
}
