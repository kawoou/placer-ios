//
//  UserServiceError.swift
//  Common
//
//  Created by Kawoou on 27/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public enum UserServiceError: Int, AbstractError {
    case failedToLogin
    case failedToRegister

    public var baseCode: Int {
        return 2100
    }
    public var reason: String {
        switch self {
        case .failedToLogin:
            return "이메일 혹은 비밀번호가 잘못되었습니다."
        case .failedToRegister:
            return "회원가입에 실패했습니다."
        }
    }
}
