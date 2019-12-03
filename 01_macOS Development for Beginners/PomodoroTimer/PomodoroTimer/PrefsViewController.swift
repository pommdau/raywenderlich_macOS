//
//  PrefsViewController.swift
//  PomodoroTimer
//
//  Created by HIROKI IKEUCHI on 2019/12/03.
//  Copyright © 2019年 ikeh1024. All rights reserved.
//

import Cocoa

class PrefsViewController: NSViewController {

    @IBOutlet weak var taskLabel: NSTextField!
    @IBOutlet weak var taskSlider: NSSlider!
    @IBOutlet weak var intervalLabel: NSTextField!
    @IBOutlet weak var intervalSlider: NSSlider!
    @IBOutlet weak var longIntervalLabel: NSTextField!
    @IBOutlet weak var longIntervalSlider: NSSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    // MARK:- IBAction Methods
    
    @IBAction func taskSliderValueChanged(_ sender: NSSlider) {
    }
    
    @IBAction func intervalSliderValueChanged(_ sender: NSSlider) {
    }
    
    @IBAction func longIntervalSliderValueChanged(_ sender: NSSlider) {
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
    }
    
}
