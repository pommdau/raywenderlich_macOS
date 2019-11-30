//
//  Preferences.swift
//  EggTimer
//
//  Created by Hiroki Ikeuchi on 2019/11/30.
//  Copyright © 2019 hikeuchi. All rights reserved.
//

import Foundation

struct Preferences {
    var selectedTime: TimeInterval {
        get {
            let savedTime = UserDefaults.standard.double(forKey: "selectedTime")
            if savedTime > 0 {
                return savedTime
            }
            return 360
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedTime")
        }
    }
    
}
