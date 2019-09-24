//
//  ValidateAnnotation.swift
//  Common
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Valid<Value> {

    // MARK: - Private

    private let validator: Validator<Value>
    private let asserts: Bool

    private var value: Value?

    // MARK: - Public

    public func isValid() -> Bool {
        return wrappedValue != nil
    }

    public var wrappedValue: Value? {
        get {
            return value
        }
        set {
            guard let newValue = newValue else {
                value = nil
                return
            }

            switch validator.validate(newValue) {
            case .success(let newValue):
                value = newValue
            case .failure(let error):
                if asserts {
                    assertionFailure(error.localizedDescription)
                }
                value = nil
            }
        }
    }

    // MARK: - Lifecycle

    public init(
        _ validator: Validator<Value>,
        asserts: Bool = false
    ) {
        self.validator = validator
        self.asserts = asserts
    }
}
