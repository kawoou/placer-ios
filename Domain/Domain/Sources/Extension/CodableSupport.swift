//
//  CodableSupport.swift
//  Domain
//
//  Created by Kawoou on 20/11/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Foundation

// swiftlint:disable syntactic_sugar

internal struct JSONCodingKeys: CodingKey {
    var stringValue: String

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?

    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any]? {
        guard contains(key) else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: [Any].Type, forKey key: K) throws -> [Any]? {
        guard contains(key) else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary = [String: Any]()

        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode([String: Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode([Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}
extension UnkeyedDecodingContainer {
    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []
        while isAtEnd == false {
            if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode([String: Any].self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode([Any].self) {
                array.append(nestedArray)
            }
        }
        return array
    }
    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}

extension KeyedEncodingContainerProtocol where Key == JSONCodingKeys {
    mutating func encodeJSONDictionary(_ value: [String: Any]) throws {
        try value.forEach({ (key, value) in
            guard let key = JSONCodingKeys(stringValue: key) else { return }
            switch value {
            case let value as Bool:
                try encode(value, forKey: key)
            case let value as Int:
                try encode(value, forKey: key)
            case let value as String:
                try encode(value, forKey: key)
            case let value as Double:
                try encode(value, forKey: key)
            case let value as [String: Any]:
                try encode(value, forKey: key)
            case let value as [Any]:
                try encode(value, forKey: key)
            case Optional<Any>.none:
                try encodeNil(forKey: key)
            default:
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath + [key], debugDescription: "Invalid JSON value"))
            }
        })
    }
}

extension KeyedEncodingContainerProtocol {
    mutating func encode(_ value: [String: Any], forKey key: Key) throws {
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        try container.encodeJSONDictionary(value)
    }

    mutating func encode(_ value: [String: Any]?, forKey key: Key) throws {
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        guard let value = value else { return }
        try container.encodeJSONDictionary(value)
    }

    mutating func encode(_ value: [String: String], forKey key: Key) throws {
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        try container.encodeJSONDictionary(value)
    }

    mutating func encode(_ value: [String: String]?, forKey key: Key) throws {
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        guard let value = value else { return }
        try container.encodeJSONDictionary(value)
    }

    mutating func encodeIfPresent(_ value: [String: Any]?, forKey key: Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }

    mutating func encode(_ value: [Any], forKey key: Key) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encodeJSONArray(value)
    }

    mutating func encodeIfPresent(_ value: [Any]?, forKey key: Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }
}

extension UnkeyedEncodingContainer {
    mutating func encodeJSONArray(_ value: [Any]) throws {
        try value.enumerated().forEach({ (index, value) in
            switch value {
            case let value as Bool:
                try encode(value)
            case let value as Int:
                try encode(value)
            case let value as String:
                try encode(value)
            case let value as Double:
                try encode(value)
            case let value as [String: Any]:
                try encode(value)
            case let value as [Any]:
                try encode(value)
            case Optional<Any>.none:
                try encodeNil()
            default:
                let keys = JSONCodingKeys(intValue: index).map({ [ $0 ] }) ?? []
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath + keys, debugDescription: "Invalid JSON value"))
            }
        })
    }

    mutating func encode(_ value: [String: Any]) throws {
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self)
        try container.encodeJSONDictionary(value)
    }

    mutating func encode(_ value: [String: Any]?) throws {
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self)
        guard let value = value else { return }
        try container.encodeJSONDictionary(value)
    }

    mutating func encode(_ value: [String: String]) throws {
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self)
        try container.encodeJSONDictionary(value)
    }

    mutating func encode(_ value: [String: String]?) throws {
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self)
        guard let value = value else { return }
        try container.encodeJSONDictionary(value)
    }

    mutating func encode(_ value: [Any]) throws {
        var container = self.nestedUnkeyedContainer()
        try container.encodeJSONArray(value)
    }

    mutating func encodeJSONDictionary(_ value: [String: Any]) throws {
        var nestedContainer = self.nestedContainer(keyedBy: JSONCodingKeys.self)
        try nestedContainer.encodeJSONDictionary(value)
    }
}

// swiftlint:enable syntactic_sugar
