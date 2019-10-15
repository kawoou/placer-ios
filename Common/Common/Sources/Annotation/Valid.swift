//
//  ValidateAnnotation.swift
//  Common
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

@propertyWrapper
public struct Valid<Value> {

    // MARK: - Private

    private let validator: Validator<Value>
    private let asserts: Bool

    public private(set) var validatedValue: Result<Value, Error>

    // MARK: - Public

    public var wrappedValue: Value? {
        get {
            switch validatedValue {
            case .success(let value):
                return value
            case .failure:
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                validatedValue = .failure(ValidError.nilValue)
                return
            }

            validatedValue = validator.validate(newValue)

            if asserts {
                switch validatedValue {
                case .success: break
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                }
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
        self.validatedValue = .failure(ValidError.nilValue)
    }

    public init(
        initialValue value: Value,
        _ validator: Validator<Value>,
        asserts: Bool = false
    ) {
        self.init(validator, asserts: asserts)

        wrappedValue = value
   }
}

extension Valid: Validable {
    public func isValid() -> Bool {
        return wrappedValue != nil
    }
}

extension Valid: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = wrappedValue {
            try container.encode(value)
        }
    }
}
