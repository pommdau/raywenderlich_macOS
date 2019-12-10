//
//  PrefsViewController.swift
//  PomodoroTimer
//
//  Created by HIROKI IKEUCHI on 2019/12/09.
//  Copyright © 2019年 hikeuchi. All rights reserved.
//

import Cocoa

class PrefsViewController: NSViewController {

    @IBOutlet weak var tastTimeTextField: NSTextField!
    @IBOutlet weak var intervalTimeTextField: NSTextField!
    @IBOutlet weak var longIntervalTimeTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
    }
    
}
