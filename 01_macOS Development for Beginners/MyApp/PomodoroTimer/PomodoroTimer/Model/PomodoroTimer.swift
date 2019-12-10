//
//  PomodoroTimer.swift
//  PomodoroTimer
//
//  Created by HIROKI IKEUCHI on 2019/12/10.
//  Copyright © 2019年 hikeuchi. All rights reserved.
//

import Foundation

enum TimerMode {
    case task
    case interval
    case longInterval
}

class PomodoroTimer {
    var timer               : Timer?       = nil
    var startTime           : Date?
    var taskDuration        : TimeInterval = 25 * 60 // タスク
    var intervalDuration    : TimeInterval = 5  * 60 // インターバル
    var longIntervaluration : TimeInterval = 15 * 60 // ロングインターバル
    var elapsedTime         : TimeInterval = 0
    var pomodoroCount       : Int          = 0       // 現在のポモドーロ数(4の倍数の後にロングインターバル)
    var timerMode           : TimerMode    = TimerMode.task
    
    var isStopped: Bool {
        return timer == nil && elapsedTime == 0
    }
    
    var isPaused: Bool {
        return timer == nil && elapsedTime > 0
    }
    
    var duration: TimeInterval {
        switch timerMode {
        case TimerMode.task:
            return taskDuration
        case TimerMode.interval:
            return intervalDuration
        case TimerMode.longInterval:
            return longIntervaluration
        }
    }
    
    var delegate: PomodoroTimerProtocol?
    
    @objc dynamic func timerAction() {
        guard let startTime = startTime else {
            return
        }
        
        elapsedTime = -startTime.timeIntervalSinceNow
        
        let secondsRemaining = (duration - elapsedTime).rounded()
        
        if secondsRemaining <= 0 {
            resetTimer()
            delegate?.timerHasFinished(self)
        } else {
            delegate?.timeRemainingOnTimer(self, timeRemaining: secondsRemaining)
        }
    }
    
    func startTimer() {
        startTime = Date()
        elapsedTime = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        timerAction()
    }
    
    func resumeTimer() {
        startTime = Date(timeIntervalSinceNow: -elapsedTime)
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        timerAction()
    }
    
    // 3
    func stopTimer() {
        // really just pauses the timer
        timer?.invalidate()
        timer = nil
        
        timerAction()
    }
    
    // 4
    func resetTimer() {
        // stop the timer & reset back to start
        timer?.invalidate()
        timer = nil
        
        startTime = nil
        taskDuration = 25 * 60
        elapsedTime = 0
        
        timerAction()
    }
    
}

protocol PomodoroTimerProtocol {
    func timeRemainingOnTimer(_ timer: PomodoroTimer, timeRemaining: TimeInterval)
    func timerHasFinished(_ timer: PomodoroTimer)
}
