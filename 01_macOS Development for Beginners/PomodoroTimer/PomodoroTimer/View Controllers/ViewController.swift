//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by Hiroki Ikeuchi on 2019/11/30.
//  Copyright © 2019 ikeh1024. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var timeLeftField: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var restartButton: NSButton!
    @IBOutlet weak var skipButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    // MARK:- IBActions - buttons
    
    @IBAction func startButtonClicked(_ sender: Any) {

    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func restartButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func skipButtonClicked(_ sender: Any) {
        
    }
    
    
    // MARK: - IBActions - menus
    
    @IBAction func startTimerMenuItemSelected(_ sender: Any) {
        startButtonClicked(sender)
    }
    
    @IBAction func stopTimerMenuItemSelected(_ sender: Any) {
        stopButtonClicked(sender)
    }
    
    @IBAction func restartTimerMenuItemSelected(_ sender: Any) {
        restartButtonClicked(sender)
    }
    
    @IBAction func skipTimerMenuItemSelected(_ sender: Any) {
        skipButtonClicked(sender)
    }
}

