//
//  PrefsViewController.swift
//  PomodoroTimer
//
//  Created by HIROKI IKEUCHI on 2019/12/09.
//  Copyright © 2019年 hikeuchi. All rights reserved.
//

import Cocoa

class PrefsViewController: NSViewController {

    @IBOutlet weak var taskDurationTextField         : NSTextField!
    @IBOutlet weak var intervalDurationTextField     : NSTextField!
    @IBOutlet weak var longIntervalDurationTextField : NSTextField!
    
    var prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        showExistingPrefs()
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        saveNewPrefs()
        view.window?.close()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        view.window?.close()
    }
    
    // 設定値でUIを更新する
    func showExistingPrefs() {
        let taskDurationInMinutes         = Int(prefs.taskDuration)         / 60
        let intervalDurationInMinutes     = Int(prefs.intervalDuration)     / 60
        let longIntervalDurationInMinutes = Int(prefs.longIntervalDuration) / 60
        
        taskDurationTextField.stringValue         = "\(taskDurationInMinutes)"
        intervalDurationTextField.stringValue     = "\(intervalDurationInMinutes)"
        longIntervalDurationTextField.stringValue = "\(longIntervalDurationInMinutes)"
    }
    
    // 現在の設定値をNSUserDefaultsに保存し、通知を行う
    func saveNewPrefs() {
        prefs.taskDuration         = TimeInterval(taskDurationTextField.intValue         * 60)
        prefs.intervalDuration     = TimeInterval(intervalDurationTextField.intValue     * 60)
        prefs.longIntervalDuration = TimeInterval(longIntervalDurationTextField.intValue * 60)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PrefsChanged"),
                                        object: nil)
    }
}
