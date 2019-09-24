//
//  PlacerAPI.swift
//  Network
//
//  Created by Kawoou on 14/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common
import Moya

public enum PlacerAPI {
    case login(LoginRequest)
}

extension PlacerAPI: TargetType {
    public var baseURL: URL {
        return URL(string: NetworkConstant.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .login:
            return "/user/auth/login"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        case .login(let request):
            return .requestJSONEncodable(request)
        }
    }

    public var headers: [String: String]? {
        return [:]
    }

    public var validationType: ValidationType {
        return .successCodes
    }
}
