//
//  PlacerAPI.swift
//  Network
//
//  Created by Kawoou on 14/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Common

import Moya

enum PlacerAPI {
    case login(LoginRequest)
}

extension PlacerAPI: TargetType {
    var baseURL: URL {
        return URL(string: NetworkConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/user/auth/login"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .login(let request):
            return .requestJSONEncodable(request)
        }
    }

    var headers: [String: String]? {
        return [:]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
