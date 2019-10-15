//
//  Validable.swift
//  Common
//
//  Created by Kawoou on 27/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

public protocol Validable {
    var target: [Validable] { get }
}

public extension Validable {
    var target: [Validable] {
        return []
    }

    func isValid() -> Bool {
        target.reduce(true) { $0 && $1.isValid() }
    }
}
