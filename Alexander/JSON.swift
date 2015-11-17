//
//  JSON.swift
//  Alexander
//
//  Created by Caleb Davenport on 6/24/15.
//  Copyright (c) 2015 Hodinkee. All rights reserved.
//

import Foundation

enum AlexanderError: ErrorType {
    case InvalidObject
}

public struct JSON {
    
    // MARK: - Initializers
    
    public init(object: AnyObject) {
        self.object = object
    }

    
    // MARK: - Properties
    
    public var object: AnyObject

    public subscript(index: Int) -> JSON? {
        let array = object as? [AnyObject]
        return (array?[index]).map({ JSON(object: $0) })
    }

    public subscript(key: String) -> JSON? {
        let dictionary = object as? [String: AnyObject]
        return (dictionary?[key]).map({ JSON(object: $0) })
    }

    public var string: String? {
        return object as? String
    }

    public var dictionary: [String: JSON]? {
        return (object as? [String: AnyObject])?.mapValues({ JSON(object: $0) })
    }

    public var array: [JSON]? {
        return (object as? [AnyObject])?.map({ JSON(object: $0) })
    }

    public var int: Int? {
        return object as? Int
    }

    public var double: Double? {
        return object as? Double
    }

    public var bool: Bool? {
        return object as? Bool
    }

    public var url: NSURL? {
        return string.flatMap({ NSURL(string: $0) })
    }

    public var timeInterval: NSTimeInterval? {
        return object as? NSTimeInterval
    }

    public var date: NSDate? {
        return timeInterval.map({ NSDate(timeIntervalSince1970: $0) })
    }
    
    
    // MARK: - Functions

    public func decode<T>(transform: JSON -> T?) -> T? {
        return transform(self)
    }
    
    public func decodeArray<T>(transform: JSON -> T?) -> [T]? {
        return (object as? [AnyObject])?.lazy
            .map(JSON.init)
            .map(transform)
            .flatMap({ $0 })
    }
}

extension JSON {
    public init(data: NSData, options: NSJSONReadingOptions = []) throws {
        self.object = try NSJSONSerialization.JSONObjectWithData(data, options: options)
    }

    public func data(options: NSJSONWritingOptions = []) throws -> NSData {
        if NSJSONSerialization.isValidJSONObject(object) {
            return try NSJSONSerialization.dataWithJSONObject(object, options: options)
        }
        throw AlexanderError.InvalidObject
    }
}

extension JSON: CustomDebugStringConvertible {
    public var debugDescription: String {
        if
            let data = try? self.data(.PrettyPrinted),
            let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return String(string)
        }
        return "Invalid JSON."
    }

}
