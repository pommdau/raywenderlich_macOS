//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by HIROKI IKEUCHI on 2019/12/09.
//  Copyright © 2019年 hikeuchi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var timeLeftField: NSTextField!
    @IBOutlet weak var leftButton: NSButton!
    @IBOutlet weak var rightButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func leftButtonClicked(_ sender: Any) {
    }
    
    @IBAction func rightButtonClicked(_ sender: Any) {
    }
    
    
    // MARK: - IBActions - menus
    
    @IBAction func startTimerMenuItemSelected(_ sender: Any) {
        leftButtonClicked(sender)
    }
    
    @IBAction func stopTimerMenuItemSelected(_ sender: Any) {
        rightButtonClicked(sender)
    }
}

