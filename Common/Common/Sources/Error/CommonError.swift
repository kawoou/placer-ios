//
//  CommonError.swift
//  Common
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public enum CommonError: Int, AbstractError {
    case nilSelf

    public var baseCode: Int {
        return 1000
    }
    public var reason: String {
        switch self {
        case .nilSelf:
            return "원인을 알 수 없는 에러가 발생했습니다."
        }
    }
}
