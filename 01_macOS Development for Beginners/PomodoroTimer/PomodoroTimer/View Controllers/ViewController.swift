//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by Hiroki Ikeuchi on 2019/11/30.
//  Copyright © 2019 ikeh1024. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    @IBOutlet weak var timeLeftField: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var restartButton: NSButton!
    @IBOutlet weak var skipButton: NSButton!

    var pomodoroTimer = PomodoroTimer()
    var prefs = Preferences()
    var soundPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pomodoroTimer.delegate = self
        setupPrefs()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    // MARK:- IBActions - buttons
    
    @IBAction func startButtonClicked(_ sender: Any) {
        if pomodoroTimer.isPaused {
            pomodoroTimer.resumeTimer()
        } else {
            pomodoroTimer.duration = prefs.taskTime
            pomodoroTimer.startTimer()
        }
        configureButtonsAndMenus()
        prepareSound()
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        pomodoroTimer.stopTimer()
        configureButtonsAndMenus()
    }
    
    @IBAction func restartButtonClicked(_ sender: Any) {
        pomodoroTimer.resetTimer()
        updateDisplay(for: prefs.taskTime)
        configureButtonsAndMenus()
    }
    
    @IBAction func skipButtonClicked(_ sender: Any) {
        // TODO: implement
        configureButtonsAndMenus()
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

extension ViewController {
    
    // MARK:- Display
    
    func updateDisplay(for timeRemaining: TimeInterval) {
        timeLeftField.stringValue = textToDisplay(for: timeRemaining)
    }
    
    // ここでのみ使用するのでprivate
    private func textToDisplay(for timeRemaining: TimeInterval) -> String {
        if timeRemaining == 0 { // タイマが終了している場合はDone!を表示する
            return "Done!"
        }
        
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)

        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        let timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    
    // メインウィンドウのボタンとメニューバーの
    func configureButtonsAndMenus() {
        let enableStart: Bool
        let enableStop : Bool
        let enableReset: Bool
        let enableSkip : Bool
        
        if pomodoroTimer.isStopped {
            enableStart = true
            enableStop  = false
            enableReset = false
            enableSkip  = true
        } else if pomodoroTimer.isPaused {
            enableStart = true
            enableStop  = false
            enableReset = true
            enableSkip  = true
        } else {    // タイマーが稼働中
            enableStart = false
            enableStop  = true
            enableReset = false
            enableSkip  = true
        }
        
        startButton.isEnabled   = enableStart
        stopButton.isEnabled    = enableStop
        restartButton.isEnabled = enableReset
        skipButton.isEnabled    = enableSkip
        
        if let appDel = NSApplication.shared.delegate as? AppDelegate {
            appDel.enableMenus(start: enableStart, stop: enableStop, reset: enableReset, skip: enableSkip)
        }
        
    }
}

extension ViewController {
    
    // MARK:- Preferences
    
    // 設定に関する初期設定
    func setupPrefs() {
        updateDisplay(for: prefs.taskTime)
        
        let notificationName = Notification.Name(rawValue: "PrefsChanged")
        NotificationCenter.default.addObserver(forName: notificationName,
                                               object: nil, queue: nil) {
                                                (Notification) in
                                                self.checkForResetAfterPrefsChange()
        }
        
    }
    
    func updateFromPrefs() {
        self.pomodoroTimer.duration = self.prefs.taskTime
        self.restartButtonClicked(self)
    }
    
    func checkForResetAfterPrefsChange() {
        if pomodoroTimer.isStopped || pomodoroTimer.isPaused {
            // 1
            updateFromPrefs()
        } else {
            // 2
            let alert = NSAlert()
            alert.messageText = "Reset timer with the new settings?"
            alert.informativeText = "This will stop your current timer!"
            alert.alertStyle = .warning
            
            // 3
            alert.addButton(withTitle: "Reset")
            alert.addButton(withTitle: "Cancel")
            
            // 4
            let response = alert.runModal()
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                self.updateFromPrefs()
            }
        }
    }
}

extension ViewController {
    
    
    // MARK: - Sound
    
    func prepareSound() {
        guard let audioFileUrl = Bundle.main.url(forResource: "ding", withExtension: "mp3") else {
            return
        }
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            soundPlayer?.prepareToPlay()
        } catch {
            print("Sound player not available: \(error)")
        }
    }
    
    func playSound() {
        soundPlayer?.play()
    }
}


// MARK:- PomodoroTimerProtocol Methods

extension ViewController: PomodoroTimerProtocol {
    func timeRemainingOnTimer(_ timer: PomodoroTimer,
                              timeRemaining: TimeInterval) {
        updateDisplay(for: timeRemaining)
    }
    
    func timerHasFinished(_ timer: PomodoroTimer) {
        updateDisplay(for: 0)
        playSound()
    }
}
