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
    @IBOutlet weak var statusLabel: NSTextField!
    
    var pomodoroTimer = PomodoroTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pomodoroTimer.delegate = self
        
        updateDisplay(for: pomodoroTimer.duration)
        configureButtonsAndMenus()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func leftButtonClicked(_ sender: Any) {
        switch pomodoroTimer.timerMode {
        case .task:
            if pomodoroTimer.isPaused {         // 一時停止中
                pomodoroTimer.resumeTimer()
            } else if pomodoroTimer.isStopped { // 計測前
                pomodoroTimer.startTimer()
            } else {                            // 計測中
                pomodoroTimer.pauseTimer()
            }
        case .interval, .longInterval :
            if pomodoroTimer.isPaused {         // 一時停止中
                pomodoroTimer.resumeTimer()
            } else if pomodoroTimer.isStopped { // 計測前
                print("（Error）ここは通らないようにする")
                pomodoroTimer.startTimer()
            } else {                            // 計測中
                pomodoroTimer.pauseTimer()
            }
        }
        configureButtonsAndMenus()
    }
    
    @IBAction func rightButtonClicked(_ sender: Any) {
        switch pomodoroTimer.timerMode {
        case .task:
            if pomodoroTimer.isPaused {         // 一時停止中
                pomodoroTimer.completeTimer()
            } else if pomodoroTimer.isStopped { // 計測前
                print("（Error）ここは通らないはず")
            } else {                            // 計測中
                pomodoroTimer.resetTimer()
                updateDisplay(for: pomodoroTimer.duration)
            }
        case .interval, .longInterval :
            if pomodoroTimer.isPaused {         // 一時停止中
                pomodoroTimer.completeTimer()
            } else if pomodoroTimer.isStopped { // 計測前
                print("（Error）ここは通らないはず")
            } else {                            // 計測中
                pomodoroTimer.completeTimer()
            }
        }
        configureButtonsAndMenus()
    }
    
    
    // MARK: - IBActions - menus
    
    @IBAction func startTimerMenuItemSelected(_ sender: Any) {
        leftButtonClicked(sender)
    }
    
    @IBAction func stopTimerMenuItemSelected(_ sender: Any) {
        rightButtonClicked(sender)
    }
}

extension ViewController: PomodoroTimerProtocol {
    func timeRemainingOnTimer(_ timer: PomodoroTimer, timeRemaining: TimeInterval) {
        updateDisplay(for: timeRemaining)
    }
    
    func timerHasFinished(_ timer: PomodoroTimer) {
        updateDisplay(for: pomodoroTimer.duration)
    }
}

extension ViewController {
    
    // MARK: - Display
    
    func updateDisplay(for timeRemaining: TimeInterval) {
        timeLeftField.stringValue = textToDisplay(for: timeRemaining)
        
        switch pomodoroTimer.timerMode {
        case .task:
            statusLabel.stringValue = "Pomodoro #\(pomodoroTimer.pomodoroCount)"
        case .interval:
            statusLabel.stringValue = "Interval"
        case .longInterval :
            statusLabel.stringValue = "Long Interval"
        }
    }
    
    // 残り時間の表示文字列の作成
    private func textToDisplay(for timeRemaining: TimeInterval) -> String {
        if timeRemaining == 0 {
            return "Done!"
        }
        
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)
        
        let minutesDisplay = String(format: "%02d", Int(minutesRemaining))
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        let timeRemainingDisplay = "\(minutesDisplay):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    
    func configureButtonsAndMenus() {
        
        rightButton.isEnabled = true
        leftButton.isEnabled  = true
        switch pomodoroTimer.timerMode {
        case .task:
            if pomodoroTimer.isPaused {         // 一時停止中
                leftButton.title  = "Resume"
                rightButton.title = "Complete"
            } else if pomodoroTimer.isStopped { // 計測前
                leftButton.title  = "Start"
                rightButton.title = "Stop"
                rightButton.isEnabled   = false
            } else {                            // 計測中
                leftButton.title = "Pause"
                rightButton.title = "Stop"
            }
        case .interval, .longInterval :
            if pomodoroTimer.isPaused {         // 一時停止中
                leftButton.title = "Resume"
                rightButton.title = "Skip"
            } else if pomodoroTimer.isStopped { // 計測前
                // ここは表示しないようにする予定
                leftButton.title = "Start"
                rightButton.title = "Stop"
                rightButton.isEnabled = false
            } else {                            // 計測中
                leftButton.title = "Pause"
                rightButton.title = "Skip"
            }
        }
        
        if let appDel = NSApplication.shared.delegate as? AppDelegate {
            appDel.configureMenus(leftTitle: leftButton.title, rightTitle: rightButton.title)
        }
    }
}


