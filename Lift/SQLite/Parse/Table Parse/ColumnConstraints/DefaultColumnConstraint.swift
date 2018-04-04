//
//  DefaultColumnConstraint.swift
//  Lift
//
//  Created by Carl Wieland on 9/29/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Foundation

enum DefaultValue {
    case null
    case current_time
    case current_date
    case current_timestamp
    case literal(SQLiteName)
    case expression(String)

    init(text: String) {
        switch text.uppercased() {
        case "NULL":
            self = .null
        case "CURRENT_DATE":
            self = .current_date
        case "CURRENT_TIME":
            self = .current_time
        case "CURRENT_TIMESTAMP":
            self = .current_timestamp
        default:
            self = .literal(SQLiteName(rawValue:text))
        }
    }

    var sql: String {
        switch self {
        case .null:
            return "NULL"
        case .current_date:
            return "CURRENT_DATE"
        case .current_time:
            return "CURRENT_TIME"
        case .current_timestamp:
            return "CURRENT_TIMESTAMP"
        case .literal(let val):
            return val.rawValue
        case .expression(let expr):
            return expr
        }
    }
}


class DefaultColumnConstraint: ColumnConstraint {

    var value: DefaultValue

    init(with name: SQLiteName?, from scanner: Scanner) throws {

        guard scanner.scanString("DEFAULT", into: nil) else {
            throw ParserError.unexpectedError("Expecting to parse default col const")
        }

        if scanner.scanString("(", into: nil) {
            //move back to before the exp so balancing works out
            scanner.scanLocation -= 1
            value = .expression(try SQLiteCreateTableParser.parseExp(from: scanner))
        } else if scanner.scanString("NULL", into: nil) {
            value = .null
        } else if scanner.scanString("CURRENT_TIME", into: nil) {
            value = .current_time
        } else if scanner.scanString("CURRENT_DATE", into: nil) {
            value = .current_date
        } else if scanner.scanString("CURRENT_TIMESTAMP", into: nil) {
            value = .current_timestamp
        } else {
            value = .literal(try SQLiteCreateTableParser.parseStringOrName(from: scanner))
        }


        super.init(name: name)
    }

    init(value: DefaultValue) {
        self.value = value
        super.init(name: nil)
    }

    override var sql: String {
        var builder = ""
        if let name = constraintName {
            builder += "CONSTRAINT \(name) "
        }

        return builder + "DEFAULT \(value.sql)"
    }
}
