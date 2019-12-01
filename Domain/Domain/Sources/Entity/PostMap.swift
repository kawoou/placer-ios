//
//  PostMap.swift
//  Domain
//
//  Created by Kawoou on 24/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public struct PostMap: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id
        case writerNickname = "writerNickName"
        case imageUrl = "address"
        case content = "comment"
        case likeCount = "like"
        case longitude
        case latitude
        case createdAt = "timestamp"
    }

    public let id: Int
    public let writerNickname: String
    public let imageUrl: String
    public let content: String?
    public let likeCount: Int
    public let longitude: Double
    public let latitude: Double
    public let createdAt: Date

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.writerNickname = try container.decode(String.self, forKey: .writerNickname)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.latitude = try container.decode(Double.self, forKey: .latitude)

        let createdAt = try container.decode(Double.self, forKey: .createdAt)
        self.createdAt = Date(timeIntervalSince1970: createdAt / 1000)
    }

    public init(id: Int, writerNickname: String, imageUrl: String, content: String?, likeCount: Int, longitude: Double, latitude: Double, createdAt: Date) {
        self.id = id
        self.writerNickname = writerNickname
        self.imageUrl = imageUrl
        self.content = content
        self.likeCount = likeCount
        self.longitude = longitude
        self.latitude = latitude
        self.createdAt = createdAt
    }
}
