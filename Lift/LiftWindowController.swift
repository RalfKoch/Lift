//
//  LiftWindowController.swift
//  Lift
//
//  Created by Carl Wieland on 10/3/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Cocoa

class LiftWindowController: NSWindowController {


    @IBAction func unwindFromAttachingDatabase(_ sender: Any? ) {

    }


    @IBAction func showAttachDetach(_ sender: NSSegmentedControl) {
        
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        (segue.destinationController as? NSViewController)?.representedObject = document
    }

    override var document: AnyObject? {
        didSet {
            contentViewController?.representedObject = document
        }
    }

    override var contentViewController: NSViewController? {
        didSet {
            contentViewController?.representedObject = document
        }
    }
}
