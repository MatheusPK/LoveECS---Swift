//
//  LoveUtils.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation

class LoveUtils {
    class Timer {
        var interval: TimeInterval = .infinity
        var timer: TimeInterval = .zero
        
        init(interval: TimeInterval) {
            self.interval = interval
        }
        
        func fired(_ increment: TimeInterval, speed: TimeInterval)-> Bool {
            interval = speed
            if timer >= interval {
                timer = .zero
                return true
            }
            timer += increment
            return false
        }
    }
}
