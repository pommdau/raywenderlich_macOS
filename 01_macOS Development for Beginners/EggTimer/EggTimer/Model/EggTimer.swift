//
//  EggTimer.swift
//  EggTimer
//
//  Created by HIROKI IKEUCHI on 2019/11/29.
//  Copyright © 2019年 hikeuchi. All rights reserved.
//

import Foundation

protocol EggTimerProtocol {
    func timeRemainingOnTimer(_ timer: EggTimer, timeRemaining: TimeInterval)
    func timerHasFinished(_ timer: EggTimer)
}

class EggTimer {
    
    var timer: Timer? = nil
    var startTime: Date?
    var duration: TimeInterval = 360    // タイマの期間。default = 6  minutes
    var elapsedTime: TimeInterval = 0   // 経過時間。really means Double
    
    var isStopped: Bool {
        return timer == nil && elapsedTime == 0
    }
    
    var isPaused: Bool {
        return timer == nil && elapsedTime > 0
    }
    
    var delegate: EggTimerProtocol?
    
    // タイマで毎時呼ばれるアクション
    // dynamicはObjective-Cランタイムのときに使う、程度の認識でOK
    @objc dynamic func timerAction() {
        // 1 タイマがない場合は実行しない
        guard let startTime = startTime else {
            return
        }
        
        // 2 startTimeは過去なのでマイナスで反転させる
        elapsedTime = -startTime.timeIntervalSinceNow
        
        // 3 タイマーの残り時間
        let secondsRemaining = (duration - elapsedTime).rounded()
        
        // 4 タイマーが終了した場合の処理
        if secondsRemaining <= 0 {
            resetTimer()
            delegate?.timerHasFinished(self)
        } else {
            delegate?.timeRemainingOnTimer(self, timeRemaining: secondsRemaining)
        }
    }
    
    // 1
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
    
    // 2 タイマの一時停止しているとき、再起動時に使う
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
        duration = 360
        elapsedTime = 0
        
        timerAction()
    }
}
