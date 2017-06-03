//
//  ViewController.swift
//  AmusementParkPassGenerator
//
//  Created by William Vivas on 5/15/17.
//  Copyright © 2017 William Vivas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func scan(entrant: EntrantType, accessType: AccessType) {
        PassScanner.scan(entrant: entrant, accessType: accessType)
    }
}

