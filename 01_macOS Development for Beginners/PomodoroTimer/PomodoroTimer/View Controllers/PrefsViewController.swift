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
    @IBOutlet weak var intervalLabel: NSTextField!
    @IBOutlet weak var longIntervalLabel: NSTextField!
    @IBOutlet weak var taskSlider: NSSlider!
    @IBOutlet weak var intervalSlider: NSSlider!
    @IBOutlet weak var longIntervalSlider: NSSlider!
    
    var prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        showExistingPrefs()
    }
    
    func showExistingPrefs() {
        let taskTimeInMinutes = Int(prefs.taskTime) / 60 // 残り時間（分）
        let intervalTimeInMinutes = Int(prefs.intervalTime) / 60
        let longIntervalTimeInMinutes = Int(prefs.longIntervalTime) / 60
        
        taskSlider.integerValue = taskTimeInMinutes
        intervalSlider.integerValue = intervalTimeInMinutes
        longIntervalSlider.integerValue = longIntervalTimeInMinutes
        showAllSliderValuesAsText()
    }
    
    // 現在のSliderの値でラベル表記を更新する
    func showAllSliderValuesAsText() {
        showSliderValueAsText(taskLabel, taskSlider)
        showSliderValueAsText(intervalLabel, intervalSlider)
        showSliderValueAsText(longIntervalLabel, longIntervalSlider)
    }
    
    func showSliderValueAsText(_ label: NSTextField, _ slider: NSSlider) {
        let newTimerDuration = slider.integerValue
        let minutesDescription = (newTimerDuration == 1) ? "minute" : "minutes"
        label.stringValue = "\(newTimerDuration) \(minutesDescription)"
    }
    
    func saveNewPrefs() {
        prefs.taskTime = taskSlider.doubleValue * 60
        prefs.intervalTime = intervalSlider.doubleValue * 60
        prefs.longIntervalTime = longIntervalSlider.doubleValue * 60
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "PrefsChanged"),
            object: nil
        )
    }
    
    
    // MARK:- IBAction Methods
    
    @IBAction func taskSliderValueChanged(_ sender: NSSlider) {
        showAllSliderValuesAsText()
    }
    
    @IBAction func intervalSliderValueChanged(_ sender: NSSlider) {
        showAllSliderValuesAsText()
    }
    
    @IBAction func longIntervalSliderValueChanged(_ sender: NSSlider) {
        showAllSliderValuesAsText()
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        saveNewPrefs()  // TODO: モードレスネスにしたい
        view.window?.close()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        view.window?.close()
    }
}
