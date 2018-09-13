//
//  ColumnName.swift
//  Lift
//
//  Created by Carl Wieland on 9/29/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Foundation

class SQLiteName: NSObject {

    @objc dynamic public var rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    var isEmpty: Bool {
        return rawValue.isEmpty
    }

    static let invalidChars: CharacterSet = {
        var set = CharacterSet.alphanumerics.inverted
        set.remove(charactersIn: "_")
        return set
    }()

    var sql: String {
        return rawValue.sqliteSafeString()
    }

    var copy: SQLiteName {
        return SQLiteName(rawValue: rawValue)
    }

    var cleanedVersion: String {
        if (rawValue.first == "\"" || rawValue.first == "'" || rawValue.first == "`") && rawValue.balancedQoutedString() {
            return String(rawValue.dropFirst().dropLast())
        } else if rawValue.first == "[" && rawValue.last == "]" {
            return String(rawValue.dropFirst().dropLast())
        } else {
            return rawValue
        }
    }

    static func += (lhs: inout SQLiteName, rhs: String) {
        lhs.rawValue += rhs
    }

}

func + (lhs: SQLiteName, rhs: SQLiteName) -> SQLiteName {
    return SQLiteName(rawValue: lhs.rawValue + rhs.rawValue)
}

func + (lhs: SQLiteName, rhs: String) -> SQLiteName {
    return SQLiteName(rawValue: lhs.rawValue + rhs)
}

func == (lhs: SQLiteName, rhs: String) -> Bool {
    return lhs.rawValue == rhs
}

func == (lhs: SQLiteName, rhs: SQLiteName) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

func != (lhs: SQLiteName, rhs: SQLiteName) -> Bool {
    return lhs.rawValue != rhs.rawValue
}