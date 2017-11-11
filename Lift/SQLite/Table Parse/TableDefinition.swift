//
//  TableDefinition.swift
//  Lift
//
//  Created by Carl Wieland on 9/28/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Foundation

class TableDefinition: NSObject {
    @objc dynamic public var isTemp = false {
        didSet {
            if isTemp {
                databaseName = SQLiteName(rawValue: "temp")
            } else {
                databaseName = nil
            }
        }
    }
    @objc dynamic public var withoutRowID = false
    @objc dynamic public var databaseName: SQLiteName? {
        didSet {
            if isTemp && databaseName?.rawValue != "temp" {
                isTemp = false
            }
        }
    }
    @objc dynamic public var tableName = SQLiteName(rawValue: "")

    
    @objc dynamic public var columns = [ColumnDefinition]()

     @objc dynamic public var tableConstraints = [TableConstraint]()


    var qualifiedNameForQuery: String {
        if let schemaName = databaseName {
            return "\(schemaName.sql).\(tableName.sql)"
        } else {
            return tableName.sql
        }
    }

    var createStatment: String {
        var builder = "CREATE TABLE "

        if let dbName = databaseName {
            builder += dbName.sql + "." + tableName.sql
        } else {
            builder += tableName.sql
        }
        builder += "("

        builder += columns.map({ $0.creationStatement}).joined(separator: ", ")

        builder += tableConstraints.flatMap({ $0.sql }).joined(separator: ", ")

        builder += ") "

        if withoutRowID {
            builder += "WITHOUT ROWID"
        }

        return builder

    }

    func createStatement(with includedColumnNames: [String], checkExisting: Bool) -> String {

        var builder = "CREATE TABLE "
        if checkExisting {
            builder += "IF NOT EXISTS "
        }
        if let dbName = databaseName {
            builder += dbName.sql + "." + tableName.sql
        } else {
            builder += tableName.sql
        }
        builder += "("

        let includedColumns = columns.filter({includedColumnNames.contains($0.name.cleanedVersion) })
        builder += includedColumns.map({ $0.creationStatement}).joined(separator: ", ")

        let tabConstraints = tableConstraints.flatMap({ $0.sql(with: includedColumnNames )})
        if !tabConstraints.isEmpty {
            builder += "," + tabConstraints.joined(separator: ", ")
        }

        builder += ") "
        if withoutRowID {
            builder += "WITHOUT ROWID"
        }

        return builder
    }

}
