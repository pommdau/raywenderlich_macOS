//
//  Preferences.swift
//  PomodoroTimer
//
//  Created by HIROKI IKEUCHI on 2019/12/04.
//  Copyright © 2019年 ikeh1024. All rights reserved.
//

import Foundation

struct Preferences {
    let taskTimeKey         = "taskTime"
    let intervalTimeKey     = "intervalTimeKey"
    let longIntervalTimeKey = "longIntervalTimeKe"
    
    var taskTime: TimeInterval {
        get {
            let savedTime = UserDefaults.standard.double(forKey: taskTimeKey)
            if savedTime > 0 {
                return savedTime
            }
            return 360  // when not defined
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: taskTimeKey)
        }
    }
    
    var intervalTime: TimeInterval {
        get {
            let savedTime = UserDefaults.standard.double(forKey: intervalTimeKey)
            if savedTime > 0 {
                return savedTime
            }
            return 360  // when not defined
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: intervalTimeKey)
        }
    }
    
    var longIntervalTime: TimeInterval {
        get {
            let savedTime = UserDefaults.standard.double(forKey: longIntervalTimeKey)
            if savedTime > 0 {
                return savedTime
            }
            return 360  // when not defined
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: longIntervalTimeKey)
        }
    }
}
