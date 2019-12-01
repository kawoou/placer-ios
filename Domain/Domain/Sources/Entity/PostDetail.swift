//
//  PostDetail.swift
//  Domain
//
//  Created by Kawoou on 07/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public struct PostDetail: Codable {
    enum CodingKeys: String, CodingKey {
        case postId
        case aperture
        case focalLength
        case exposureTime
        case iso
        case flash
        case manufacturer
        case lensModel
        case altitude
        case latitude
        case longitude
    }

    // MARK: - Property

    public let postId: Int

    /// 조리개 값
    public let aperture: Double?

    /// 초점 거리
    public let focalLength: Double?

    /// 노출 시간
    /// 1/n 형식
    public let exposureTime: Int?

    /// ISO
    public let iso: Int?

    /// Flash
    public let flash: Bool?

    /// 제조사
    public let manufacturer: String?

    /// 렌즈 모델
    public let lensModel: String?

    /// 고도
    public let altitude: Double?

    public let latitude: Double
    public let longitude: Double

    // MARK: - Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.postId = try container.decode(Int.self, forKey: .postId)
        self.aperture = try container.decodeIfPresent(Double.self, forKey: .aperture)
        self.focalLength = try container.decodeIfPresent(Double.self, forKey: .focalLength)
        self.exposureTime = try container.decodeIfPresent(Int.self, forKey: .exposureTime)
        self.iso = try container.decodeIfPresent(Int.self, forKey: .iso)
        self.flash = try container.decodeIfPresent(Bool.self, forKey: .flash)
        self.manufacturer = try container.decodeIfPresent(String.self, forKey: .manufacturer)
        self.lensModel = try container.decodeIfPresent(String.self, forKey: .lensModel)
        self.altitude = try container.decodeIfPresent(Double.self, forKey: .altitude)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
    }

    public init(
        postId: Int,
        aperture: Double?,
        focalLength: Double?,
        exposureTime: Int?,
        iso: Int?,
        flash: Bool?,
        manufacturer: String?,
        lensModel: String?,
        altitude: Double?,
        latitude: Double,
        longitude: Double
    ) {
        self.postId = postId
        self.aperture = aperture
        self.focalLength = focalLength
        self.exposureTime = exposureTime
        self.iso = iso
        self.flash = flash
        self.manufacturer = manufacturer
        self.lensModel = lensModel
        self.altitude = altitude
        self.latitude = latitude
        self.longitude = longitude
    }
}
