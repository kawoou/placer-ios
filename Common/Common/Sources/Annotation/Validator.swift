//
//  Validator.swift
//  Common
//
//  Created by Kawoou on 23/09/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

enum ValidatorError: Error {
    case notEqual
    case equal
    case notLessThan
    case notGreaterThan
    case emptyCollection
    case invalidEmail
    case limitedStringLength
    case emptyString
    case notMatchedRegularExpression
    case limitedRange
    case shouldNotBeSuccess
    case doubleFailure
}

public struct Validator<Value> {
    let validate: (Value) -> Result<Value, Error>

    init(_ validate: @escaping (Value) -> Result<Value, Error>) {
        self.validate = validate
    }
}

public extension Validator where Value: Equatable {
    static func equal(_ otherValue: Value) -> Validator<Value> {
        return Validator {
            if $0 == otherValue {
                return .success($0)
            } else {
                return .failure(ValidatorError.notEqual)
            }
        }
    }
    static func notEqual(_ otherValue: Value) -> Validator<Value> {
        return Validator {
            if $0 != otherValue {
                return .success($0)
            } else {
                return .failure(ValidatorError.equal)
            }
        }
    }
}

public extension Validator where Value: Comparable {
    static func lessThan(_ otherValue: Value) -> Validator<Value> {
        return Validator {
            if $0 < otherValue {
                return .success($0)
            } else {
                return .failure(ValidatorError.notLessThan)
            }
        }
    }
    static func greaterThan(_ otherValue: Value) -> Validator<Value> {
        return Validator {
            if $0 > otherValue {
                return .success($0)
            } else {
                return .failure(ValidatorError.notGreaterThan)
            }
        }
    }
}

public extension Validator where Value: Collection {
    static var isNotEmpty: Validator<Value> {
        Validator {
            if !$0.isEmpty {
               return .success($0)
           } else {
               return .failure(ValidatorError.emptyCollection)
           }
        }
    }
}

public extension Validator where Value == String {
    static var email: Validator<Value> {
        Validator {
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

            let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
            if predicate.evaluate(with: $0) {
                return .success($0)
            } else {
                return .failure(ValidatorError.invalidEmail)
            }
        }
    }
    static func limitLength(min: UInt = 0, max: UInt = UInt.max) -> Validator<Value> {
        return Validator {
            if (min...max).contains(UInt($0.count)) {
                return .success($0)
            } else {
                return .failure(ValidatorError.limitedStringLength)
            }
        }
    }
    static var isNotEmpty: Validator<Value> {
        Validator {
            if !$0.isEmpty && !$0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
               return .success($0)
           } else {
               return .failure(ValidatorError.emptyString)
           }
        }
    }
    static func regex(_ pattern: String) -> Validator<Value> {
        Validator {
            let predicate = NSPredicate(format:"SELF MATCHES %@", pattern)
            if predicate.evaluate(with: $0) {
                return .success($0)
            } else {
                return .failure(ValidatorError.notMatchedRegularExpression)
            }
        }
    }
}

public extension Validator where Value: FixedWidthInteger {
    static func limit(min: Value = .min, max: Value = .max) -> Validator<Value> {
        return Validator {
            if (min...max).contains($0) {
                return .success($0)
            } else {
                return .failure(ValidatorError.limitedRange)
            }
        }
    }
}

public extension Validator {
    static prefix func !<T> (_ validator: Validator<T>) -> Validator<T> {
        return .init {
            switch validator.validate($0) {
            case .success:
                return .failure(ValidatorError.shouldNotBeSuccess)
            case .failure:
                return .success($0)
            }
        }
    }

    static func &&<T> (lhs: Validator<T>, rhs: Validator<T>) -> Validator<T> {
        return .init {
            switch (lhs.validate($0), rhs.validate($0)) {
            case (.success, .success):
                return .success($0)
            case (_, .failure(let error)):
                return .failure(error)
            case (.failure(let error), _):
                return .failure(error)
            }
        }
    }

    static func ||<T> (lhs: Validator<T>, rhs: Validator<T>) -> Validator<T> {
        return .init {
            switch (lhs.validate($0), rhs.validate($0)) {
            case (.success, .success):
                return .success($0)
            case (.success, .failure):
                return .success($0)
            case (.failure, .success):
                return .success($0)
            case (.failure, .failure):
                return .failure(ValidatorError.doubleFailure)
            }
        }
    }
}

//public extension Valid where Value: Numeric & Comparable {
//    init(min: Value, max: Value, asserts: Bool = false) {
//        self.init({ (min...max).contains($0) }, asserts: asserts, message: { "Error: \($0) not between \(min) and \(max)" })
//    }
//}
