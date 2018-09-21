//
//  PrimaryKeyTableConstraint.swift
//  Lift
//
//  Created by Carl Wieland on 9/29/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Foundation

struct PrimaryKeyTableConstraint: IndexedTableConstraint {

    public var name: SQLiteName?
    var indexedColumns: [IndexedColumn]

    var conflictClause: ConflictClause?

    init(with name: SQLiteName?, from scanner: Scanner) throws {
        self.name = name

        if !scanner.scanString("primary", into: nil) || !scanner.scanString("key", into: nil) || !scanner.scanString("(", into: nil) {
            throw ParserError.unexpectedError("Invalid table primary key")
        }

        indexedColumns = try PrimaryKeyTableConstraint.parseIndexColumns(from: scanner)

        guard scanner.scanString(")", into: nil) else {
            throw ParserError.unexpectedError("Failed to correctly parse index columns for an indexed table constraint!")
        }

        conflictClause = try ConflictClause(from: scanner)

    }
    init(name: String?) {
        self.name = name
        indexedColumns = []
    }

    var sql: String {
        var builder = ""
        if let name = name?.sql {
            builder += "CONSTRAINT \(name) "
        }
        builder += "PRIMARY KEY ("
        builder += indexedColumns.map({ $0.sql}).joined(separator: ", ")
        builder += ")"
        if let conflict = conflictClause {
            builder += " \(conflict.sql)"
        }
        return builder
    }

    func sql(with columns: [String]) -> String? {

        let cleanedIndexed = indexedColumns.filter { (index) -> Bool in
            return columns.contains(index.nameProvider.name.cleanedVersion)
        }

        if cleanedIndexed.isEmpty {
            return nil
        }

        var builder = ""
        if let name = name?.sql {
            builder += "CONSTRAINT \(name) "
        }
        builder += "PRIMARY KEY ("
        builder += cleanedIndexed.map({$0.sql}).joined(separator: ", ")
        builder += ")"
        if let conflict = conflictClause?.sql, !conflict.isEmpty {
            builder += " \(conflict)"
        }
        return builder

    }
}
