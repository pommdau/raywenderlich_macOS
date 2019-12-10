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
        // タイマーがない場合は実行しない
        guard let startTime = startTime else {
            delegate?.timerHasFinished(self)
            return  // 残り時間に関係なく、タイマーを終了する場合の処理
        }
        
        elapsedTime = -startTime.timeIntervalSinceNow   // 経過時間
        
        let secondsRemaining = (duration - elapsedTime).rounded()   // 残り時間
        
        if secondsRemaining <= 0 {  // タイマーが完了した場合
            completeTimer()
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
    
    // 再開
    func resumeTimer() {
        startTime = Date(timeIntervalSinceNow: -elapsedTime)
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        timerAction()
    }
    
    func pauseTimer() {
        // really just pauses the timer
        timer?.invalidate()
        timer = nil
        
        timerAction()
    }
    
    func resetTimer() {
        // stop the timer & reset back to start
        // stop the timer & reset back to start
        timer?.invalidate()
        timer = nil
        
        startTime = nil
        elapsedTime = 0
        
        timerAction()
    }
    
    // タイマーを完了にする
    func completeTimer() {
        // stop the timer & reset back to start
        timer?.invalidate()
        timer = nil
        
        startTime = nil
        elapsedTime = 0
        
        if (timerMode == TimerMode.task) {  // タスクを完了にする場合
            pomodoroCount += 1
            if (pomodoroCount % 4 == 0) {
                timerMode = TimerMode.longInterval  // ロングインターバルへ移行
            } else {
                timerMode = TimerMode.interval
            }
        } else {    // インターバルを終了する場合
            timerMode = TimerMode.task
        }
        
        timerAction()
    }
}

protocol PomodoroTimerProtocol {
    func timeRemainingOnTimer(_ timer: PomodoroTimer, timeRemaining: TimeInterval)
    func timerHasFinished(_ timer: PomodoroTimer)
}
