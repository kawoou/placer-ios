//
//  Post.swift
//  Domain
//
//  Created by Kawoou on 07/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public struct Post: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case writerId
        case writerNickname
        case imageUrl = "address"
        case content = "comment"
        case likeCount = "like"
        case isLiked
        case createdAt
    }

    public let id: Int
    public let writerId: Int
    public let writerNickname: String
    public let imageUrl: String
    public let content: String?
    public let likeCount: Int
    public let isLiked: Bool
    public let createdAt: Date

    public init(id: Int, writerId: Int, writerNickname: String, imageUrl: String, content: String?, likeCount: Int, isLiked: Bool, createdAt: Date) {
        self.id = id
        self.writerId = writerId
        self.writerNickname = writerNickname
        self.imageUrl = imageUrl
        self.content = content
        self.likeCount = likeCount
        self.isLiked = isLiked
        self.createdAt = createdAt
    }
}
