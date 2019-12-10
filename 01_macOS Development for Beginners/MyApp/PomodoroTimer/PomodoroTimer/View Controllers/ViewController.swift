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
        
        
    }
    
    // 残り時間の表示文字列の作成
    private func textToDisplay(for timeRemaining: TimeInterval) -> String {
        if timeRemaining == 0 {
            return "Done!"
        }
        
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)
        
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        let timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    
    func configureButtonsAndMenus() {
//        let enableStart: Bool
//        let enableStop: Bool
//        let enableReset: Bool
//
//        if eggTimer.isStopped {
//            enableStart = true
//            enableStop = false
//            enableReset = false
//        } else if eggTimer.isPaused {
//            enableStart = true
//            enableStop = false
//            enableReset = true
//        } else {
//            enableStart = false
//            enableStop = true
//            enableReset = false
//        }
//
//        startButton.isEnabled = enableStart
//        stopButton.isEnabled = enableStop
//        resetButton.isEnabled = enableReset
//
//        if let appDel = NSApplication.shared().delegate as? AppDelegate {
//            appDel.enableMenus(start: enableStart, stop: enableStop, reset: enableReset)
//        }
        
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
    }
    
    
    
}


