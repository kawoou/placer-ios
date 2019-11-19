//
//  UserAPI.swift
//  Network
//
//  Created by Kawoou on 27/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common
import Moya

public enum UserAPI {
    case login(request: LoginRequest)
    case register(request: RegisterRequest)
}

extension UserAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "\(NetworkConstant.baseURL)/users")!
    }

    public var path: String {
        switch self {
        case .login:
            return "/login"
        case .register:
            return "/register"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .register:
            return .post
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        case let .login(request):
            return .requestParameters(parameters: [
                "mail": request.email ?? "",
                "password": request.password ?? ""
            ], encoding: URLEncoding.httpBody)

        case let .register(request):
            return .requestParameters(parameters: [
                "nickname": request.nickname ?? "",
                "mail": request.email ?? "",
                "password": request.password ?? ""
            ], encoding: URLEncoding.httpBody)
        }
    }

    public var headers: [String : String]? {
        return [:]
    }

    public var validationType: ValidationType {
        return .successCodes
    }
}
