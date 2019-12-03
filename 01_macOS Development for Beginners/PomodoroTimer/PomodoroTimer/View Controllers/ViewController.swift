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

    var pomodoroTimer = PomodoroTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pomodoroTimer.delegate = self
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
}


// MARK:- PomodoroTimerProtocol Methods

extension ViewController: PomodoroTimerProtocol {
    func timeRemainingOnTimer(_ timer: PomodoroTimer,
                              timeRemaining: TimeInterval) {
        updateDisplay(for: timeRemaining)
    }
    
    func timerHasFinished(_ timer: PomodoroTimer) {
        updateDisplay(for: 0)
    }
}
