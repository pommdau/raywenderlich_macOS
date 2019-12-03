//
//  PomodoroTimer.swift
//  PomodoroTimer
//
//  Created by HIROKI IKEUCHI on 2019/12/03.
//  Copyright © 2019年 ikeh1024. All rights reserved.
//

import Foundation

protocol PomodoroTimerProtocol {
    func timeRemainingOnTimer(_ timer: PomodoroTimer, timeRemaining: TimeInterval)
    func timerHasFinished(_ timer: PomodoroTimer)
}

class PomodoroTimer {
    var timer      : Timer?       = nil     // Timerオブジェクト
    var startTime  : Date?                  // タイマの開始時刻
    var duration   : TimeInterval = 60 * 25 // タイマの設定時間。default:25分
    var elapsedTime: TimeInterval = 0       // 経過時間（秒）
    
    var delegate   : PomodoroTimerProtocol?
    
    // タイマーが停止状態かどうか
    var isStopped: Bool {
        return timer == nil && elapsedTime == 0
    }
    
    // タイマーが一時停止状態かどうか
    var isPaused: Bool {
        return timer == nil && elapsedTime > 0
    }
    
    // インターバル毎に呼ばれる関数
    @objc dynamic func timerAction() {
        guard let startTime = startTime else {  // 開始時間が設定されているか
            return
        }
        
        elapsedTime = -startTime.timeIntervalSinceNow
        
        let secondsRemaining = (duration - elapsedTime).rounded()
        
        if secondsRemaining <= 0 {  // 残り時間がなくなった場合のdelegate処理
            resetTimer()
            delegate?.timerHasFinished(self)
        } else {    // 残り時間がある場合のdelegate処理（UIの更新など）
            delegate?.timeRemainingOnTimer(self, timeRemaining: secondsRemaining)
        }
    }
    
    // タイマを開始する（インターバル枚にtimerActionを呼び出す）
    func startTimer() {
        startTime = Date()
        elapsedTime = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        timerAction() // 初回呼び出し
    }
    
    func resumeTimer() {
        startTime = Date(timeIntervalSinceNow: -elapsedTime) // 開始時刻：現在時刻からelapsedTime分過去
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        timerAction()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        timerAction()   // 現在の状態でUIの更新を行う
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        
        startTime = nil
        duration = 60 * 25
        elapsedTime = 0
        
        timerAction()   // 情報をリセットした状態でUIの更新を行う
    }
    
}
