//
//  PhotoExif.swift
//  Service
//
//  Created by Kawoou on 03/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public struct PhotoExif {
    /// 조리개 값
    public let aperture: Double?

    /// 초점 거리
    public let focalLength: Double?

    /// 노출 시간
    /// 1/n 형식
    public let exposureTime: Double?

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
}
