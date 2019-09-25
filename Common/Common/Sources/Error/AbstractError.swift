//
//  AbstractError.swift
//  Common
//
//  Created by Kawoou on 25/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public protocol AbstractError: Error {
    var baseCode: Int { get }
    var reason: String { get }
    var rawValue: Int { get }
}

public extension AbstractError {
    var code: Int {
        return baseCode + rawValue
    }
}
