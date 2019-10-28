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
    case list(page: Int)
    case getDetail(postId: Int)
}

extension PostAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "\(NetworkConstant.baseURL)/posts")!
    }

    public var path: String {
        switch self {
        case let .list(page: page):
            return "/get/\(page)"
        case let .getDetail(postId: postId):
            return "/getDetail/\(postId)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .list:
            return .get
        case .getDetail:
            return .get
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        case .list:
            return .requestPlain
        case .getDetail:
            return .requestPlain
        }
    }

    public var headers: [String : String]? {
        return [:]
    }
}
