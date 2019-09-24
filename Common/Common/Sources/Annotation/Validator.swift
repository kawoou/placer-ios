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
}

//public extension Valid where Value == String {
//    init(regex: String, asserts: Bool = false) {
//        self.init({ $0.range(of: regex, options: .regularExpression) != nil },
//                  asserts: asserts,
//                  message: { "Error: \($0) doesn't match regex: \(regex)" })
//    }
//}
//
//public extension Valid where Value: FixedWidthInteger {
//    init(min: Value = .min, max: Value = .max, asserts: Bool = false) {
//        self.init({ (min...max).contains($0) }, asserts: asserts, message: { "Error: \($0) not between \(min) and \(max)" })
//    }
//}
//
//public extension Valid where Value: Numeric & Comparable {
//    init(min: Value, max: Value, asserts: Bool = false) {
//        self.init({ (min...max).contains($0) }, asserts: asserts, message: { "Error: \($0) not between \(min) and \(max)" })
//    }
//}
