//
//  Defines.swift
//  Alexander
//
//  Created by Caleb Davenport on 8/17/15.
//  Copyright © 2015 HODINKEE. All rights reserved.
//

import Foundation

extension Dictionary {
    func mapValues<T>(transform: Value -> T) -> [Key: T] {
        var mutableDictionary = [Key: T]()
        for (key, value) in self {
            mutableDictionary[key] = transform(value)
        }
        return mutableDictionary
    }
}
