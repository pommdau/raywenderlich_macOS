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
    var prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pomodoroTimer.delegate = self
        
        updateDisplay(for: pomodoroTimer.duration)
        configureButtonsAndMenus()
        
        setupPrefs()    // 設定画面
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
    
    @IBAction func resetCountButtonClicked(_ sender: Any) {
        pomodoroTimer.pomodoroCount = 1
        pomodoroTimer.resetTimer()
        updateDisplay(for: pomodoroTimer.duration)
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
        configureButtonsAndMenus()
        postCompletingNotification()
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

extension ViewController {
    
    // MARK:- Preferences
    
    func setupPrefs() {
        self.pomodoroTimer.taskDuration        = self.prefs.taskDuration
        self.pomodoroTimer.intervalDuration    = self.prefs.intervalDuration
        self.pomodoroTimer.longIntervaluration = self.prefs.longIntervalDuration
        updateDisplay(for: pomodoroTimer.duration)
        
        let notificationName = Notification.Name(rawValue: "PrefsChanged")
        NotificationCenter.default.addObserver(forName: notificationName,
                                               object: nil, queue: nil) {
                                                (notification) in
                                                self.checkForResetAfterPrefsChange()
        }
    }
    
    func updateFromPrefs() {
        self.pomodoroTimer.taskDuration        = self.prefs.taskDuration
        self.pomodoroTimer.intervalDuration    = self.prefs.intervalDuration
        self.pomodoroTimer.longIntervaluration = self.prefs.longIntervalDuration
        
        // 変更したら一律タイマーを止めちゃうよ。本当は細かく実装するべきかな…？
        pomodoroTimer.resetTimer()
        configureButtonsAndMenus()
        updateDisplay(for: pomodoroTimer.duration)
    }
    
    func checkForResetAfterPrefsChange() {
        if pomodoroTimer.isStopped || pomodoroTimer.isPaused {
            updateFromPrefs()
        } else {

            let alert = NSAlert()
            alert.messageText = "Reset timer with the new settings?"
            alert.informativeText = "This will stop your current timer!"
            alert.alertStyle = .warning
            
            alert.addButton(withTitle: "Reset")
            alert.addButton(withTitle: "Cancel")
            
            let response = alert.runModal()
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                self.updateFromPrefs()
            }
        }
    }
}

extension ViewController: NSUserNotificationCenterDelegate {
    
    // MARK: - Finish Notification
    
    func postCompletingNotification() {
        let notification = NSUserNotification()
        notification.identifier = createNotificationIdentifier()
        switch pomodoroTimer.timerMode {
        case .interval, .longInterval:
            notification.title    = "Complete working!"
            notification.subtitle = "It's time to break"
        case .task:
            notification.title    = "Finish interval!"
            notification.subtitle = "It's time to work"
        }
        notification.soundName = NSUserNotificationDefaultSoundName
        
        // Manually display the notification
        let notificationCenter = NSUserNotificationCenter.default
        notificationCenter.delegate = self
        notificationCenter.deliver(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
        print("通知を受け取りました。")
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        center.removeDeliveredNotification(notification)
        print("通知を削除しました")
    }
    
//    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
//        return true
//    }
    
    // 日付を表示する
    // e.g. 2019/12/11 14:11:32
    func createNotificationIdentifier() -> String {
        let f = DateFormatter()
        f.timeStyle = .medium
        f.dateStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        let now = Date()
        return "ikeh1024_\(f.string(from: now))"
    }
}
