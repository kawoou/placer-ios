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
        case writerNickname = "writerNickName"
        case imageUrl = "address"
        case content = "comment"
        case likeCount = "like"
        case isLiked = "myLike"
        case createdAt = "timestamp"
    }

    public let id: Int
    public let writerNickname: String
    public let imageUrl: String
    public let content: String?
    public let likeCount: Int
    public let isLiked: Bool?
    public let createdAt: Date

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.writerNickname = try container.decode(String.self, forKey: .writerNickname)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)
        self.isLiked = try container.decodeIfPresent(Bool.self, forKey: .isLiked)

        let createdAt = try container.decode(Double.self, forKey: .createdAt)
        self.createdAt = Date(timeIntervalSince1970: createdAt / 1000)
    }

    public init(id: Int, writerNickname: String, imageUrl: String, content: String?, likeCount: Int, isLiked: Bool?, createdAt: Date) {
        self.id = id
        self.writerNickname = writerNickname
        self.imageUrl = imageUrl
        self.content = content
        self.likeCount = likeCount
        self.isLiked = isLiked
        self.createdAt = createdAt
    }
}
