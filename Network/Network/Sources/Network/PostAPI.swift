//
//  PostAPI.swift
//  Network
//
//  Created by Kawoou on 27/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common
import Moya

public enum PostAPI {
    case listMap(latitude: Double, longitude: Double, zoom: Double)
    case listTime(page: Int, latitude: Double, longitude: Double, zoom: Double)
    case listPopular(page: Int, latitude: Double, longitude: Double, zoom: Double)
    case getDetail(postId: Int)
    case upload(
        nickname: String,
        comment: String,
        file: Data,
        aperture: Double?,
        focalLength: Double?,
        exposureTime: Double?,
        iso: Int?,
        flash: Bool?,
        manufacturer: String?,
        lensModel: String?,
        latitude: Double,
        longitude: Double,
        altitude: Double?,
        timestamp: Date
    )
    case toggleLike(
        postId: Int,
        userId: Int
    )
}

extension PostAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "\(NetworkConstant.baseURL)/posts")!
    }

    public var path: String {
        switch self {
        case .listMap:
            return "/getForMap"
        case let .listTime(page, _, _, _):
            return "/getByTime/\(page)"
        case let .listPopular(page, _, _, _):
            return "/getByPopularity/\(page)"
        case let .getDetail(postId: postId):
            return "/detail/\(postId)"
        case .upload:
            return "/post"
        case let .toggleLike(postId, userId):
            return "/like/\(postId)/\(userId)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .listMap:
            return .get
        case .listTime:
            return .get
        case .listPopular:
            return .get
        case .getDetail:
            return .get
        case .upload:
            return .post
        case .toggleLike:
            return .post
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        case let .listMap(latitude, longitude, zoom):
            return .requestParameters(parameters: [
                "latitude": latitude,
                "longitude": longitude,
                "zoom": zoom
            ], encoding: URLEncoding.default)

        case let .listTime(_, latitude, longitude, zoom):
            return .requestParameters(parameters: [
                "userId": UserDefaults.standard.string(forKey: "userId") ?? "",
                "latitude": latitude,
                "longitude": longitude,
                "zoom": zoom
            ], encoding: URLEncoding.default)

        case let .listPopular(_, latitude, longitude, zoom):
            return .requestParameters(parameters: [
                "userId": UserDefaults.standard.string(forKey: "userId") ?? "",
                "latitude": latitude,
                "longitude": longitude,
                "zoom": zoom
            ], encoding: URLEncoding.default)

        case .getDetail:
            return .requestPlain

        case let .upload(
            nickname,
            comment,
            file,
            aperture,
            focalLength,
            exposureTime,
            iso,
            flash,
            manufacturer,
            lensModel,
            latitude,
            longitude,
            altitude,
            timestamp
        ):
            var parameters: [String: String] = [
                "nickName": nickname,
                "comment": comment,
                "latitude": "\(latitude)",
                "longitude": "\(longitude)",
                "timestamp": "\(timestamp)"
            ]

            parameters["aperture"] = aperture.map { "\($0)" } ?? "0"
            if let focalLength = focalLength {
                parameters["focalLength"] = "\(focalLength)"
            }
            if let exposureTime = exposureTime {
                parameters["exposureTime"] = "\(Int(1 / exposureTime))"
            }
            if let iso = iso {
                parameters["iso"] = "\(iso)"
            }
            if let flash = flash {
                parameters["flash"] = "\(flash)"
            }
            if let manufacturer = manufacturer {
                parameters["manufacturer"] = "\(manufacturer)"
            }
            if let lensModel = lensModel {
                parameters["lensModel"] = "\(lensModel)"
            }
            if let altitude = altitude {
                parameters["altitude"] = "\(altitude)"
            }
            return .uploadMultipart([
                MultipartFormData(
                    provider: .data(file),
                    name: "file",
                    fileName: "\(UUID().uuidString)).jpg",
                    mimeType: "image/jpeg"
                )
            ] + parameters.map { (key, value) in
                MultipartFormData(
                    provider: .data(value.data(using: .utf8)!),
                    name: key
                )
            })

        case .toggleLike:
            return .requestPlain
        }
    }

    public var headers: [String : String]? {
        return [:]
    }

    public var validationType: ValidationType {
        return .successCodes
    }
}
