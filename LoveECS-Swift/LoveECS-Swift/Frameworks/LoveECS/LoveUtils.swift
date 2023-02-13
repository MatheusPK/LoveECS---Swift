//
//  LoveUtils.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation

class LoveUtils {
    class Timer {
        var interval: TimeInterval
        var timer: TimeInterval = .zero
        
        init(interval: TimeInterval) {
            self.interval = 1/interval
        }
        
        func fired(_ increment: TimeInterval, speed: TimeInterval)-> Bool {
            interval = 1/speed
            if timer >= interval {
                timer = .zero
                return true
            }
            timer += increment
            return false
        }
    }
}
