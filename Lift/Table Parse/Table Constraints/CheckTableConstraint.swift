//
//  CheckTableConstraint.swift
//  Lift
//
//  Created by Carl Wieland on 9/29/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Foundation

class CheckTableConstraint: TableConstraint {

    var checkExpression: String

    init(from scanner: Scanner,named name: String) throws {

        if !scanner.scanString("check", into: nil) {
            throw ParserError.unexpectedError("Invalid table check")
        }
       
        checkExpression = try SQLiteCreateTableParser.parseExp(from: scanner)

        super.init(named: name)
    }
}
