//
//  CreateTableViewController.swift
//  Lift
//
//  Created by Carl Wieland on 10/3/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Cocoa

class CreateTableViewController: LiftViewController {
    @objc dynamic var table = TableDefinition()

    @IBOutlet weak var createTabView: NSTabView!

    @IBOutlet weak var definitionTabView: NSTabView!

    @objc dynamic var databases: [String] {
        return document?.database.allDatabases.map({ $0.name }) ?? []
    }

    @IBOutlet var selectStatementView: SQLiteTextView!

    public var originalDefinition: TableDefinition? {
        return table.originalDefinition
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let waitingView = segue.destinationController as? StatementWaitingViewController {
            waitingView.delegate = self

            guard let selectedSegment = createTabView.selectedTabViewItem else {
                return
            }
            let index = createTabView.indexOfTabViewItem(selectedSegment)
            if index == 1 {
                let statement = "CREATE TABLE \(table.qualifiedNameForQuery) AS \(selectStatementView.string)"
                waitingView.operation = .statement(statement)

            } else {
                waitingView.operation = .statement(table.createStatment)
            }

            waitingView.representedObject = representedObject

        }
    }

    @IBAction func toggleCreationType(_ sender: NSSegmentedControl) {
        definitionTabView.selectTabViewItem(at: sender.selectedSegment)
    }

}

extension CreateTableViewController: StatementWaitingViewDelegate {
    func waitingView(_ view: StatementWaitingViewController, finishedSuccessfully: Bool) {
        dismiss(view)

        if finishedSuccessfully {
            dismiss(self)
            document?.database.refresh()
        }
    }
}

class CreateColumnArrayController: NSArrayController {
    // overridden to add a new object to the content objects and to the arranged objects
    override func newObject() -> Any {
        let count = (arrangedObjects as? NSArray)?.count
        return ColumnDefinition(name: "Column \( (count ?? 0) + 1)")
    }
}