//
//  Column.swift
//  Yield
//
//  Created by Carl Wieland on 4/4/17.
//  Copyright © 2017 Datum. All rights reserved.
//

import Foundation

class Column {

    let connection: sqlite3
    let definition: ColumnDefinition

    weak var table: Table?

    let type: String

    let name: String

    let primaryKey: Bool
    /*
     - 0 : "cid"
     - 1 : "name"
     - 2 : "type"
     - 3 : "notnull"
     - 4 : "dflt_value"
     - 5 : "pk"
     */
    init(rowInfo: [SQLiteData], definition: ColumnDefinition, connection: sqlite3) throws {
        self.definition = definition

        self.connection = connection

        guard case .text(let name) = rowInfo[1],
        case .text(let type) = rowInfo[2],
        case .integer(let pk) = rowInfo[5] else {
            throw NSError(domain: "SQLite", code: 2, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Invalid column info", comment: "Error message when there is invalid format for pragma table_info")])
        }

        self.name = name
        self.type = type
        self.primaryKey = pk == 1
    }
}
