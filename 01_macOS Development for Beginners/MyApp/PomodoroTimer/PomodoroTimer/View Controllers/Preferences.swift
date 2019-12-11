//
//  Preferences.swift
//  PomodoroTimer
//
//  Created by Hiroki Ikeuchi on 2019/12/10.
//  Copyright © 2019 hikeuchi. All rights reserved.
//

import Foundation

struct Preferences {
    
    var taskDuration: TimeInterval {
        get {
            let taskDuration = UserDefaults.standard.double(forKey: "taskDuration")
            if taskDuration > 0 {
                return taskDuration
            }
            return 60 * 25
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "taskDuration")
        }
    }
    
    var intervalDuration: TimeInterval {
        get {
            let intervalDuration = UserDefaults.standard.double(forKey: "intervalDuration")
            if intervalDuration > 0 {
                return intervalDuration
            }
            return 60 * 5
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "intervalDuration")
        }
    }
    
    var longIntervalDuration: TimeInterval {
        get {
            let longIntervaluration = UserDefaults.standard.double(forKey: "longIntervaluration")
            if longIntervaluration > 0 {
                return longIntervaluration
            }
            return 60 * 15
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "longIntervaluration")
        }
    }
}
