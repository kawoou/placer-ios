//
//  PostDetail.swift
//  Domain
//
//  Created by Kawoou on 07/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public struct PostDetail: Codable {

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

    public let latitude: Double
    public let longitude: Double
    public let timestamp: Date

    // MARK: - Lifecycle

    public init(
        postId: Int,
        aperture: Double?,
        focalLength: Double?,
        exposureTime: Int?,
        iso: Int?,
        flash: Bool?,
        manufacturer: String?,
        lensModel: String?,
        latitude: Double,
        longitude: Double,
        timestamp: Date
    ) {
        self.postId = postId
        self.aperture = aperture
        self.focalLength = focalLength
        self.exposureTime = exposureTime
        self.iso = iso
        self.flash = flash
        self.manufacturer = manufacturer
        self.lensModel = lensModel
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
}
