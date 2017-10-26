//
//  SQLiteStringValueFormatter.swift
//  Lift
//
//  Created by Carl Wieland on 10/3/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Foundation

class SQLiteStringValueFormatter: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let name = value as? SQLiteName else {
            return ""
        }
        return name.rawValue
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let str = value as? String else {
            return SQLiteName(rawValue: String(describing: value))
        }

        return SQLiteName(rawValue: str)
    }
}