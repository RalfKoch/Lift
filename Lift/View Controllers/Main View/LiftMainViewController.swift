//
//  LiftMainViewController.swift
//  Lift
//
//  Created by Carl Wieland on 10/26/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Cocoa

class LiftMainViewController: LiftViewController {

    var preferredSections: [DetailSection] {
        return [.database, .table]

    }
}


extension LiftMainViewController: DetailsContentProvider {

}
