//
//  SnakeMovementComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 07/02/23.
//

import Foundation

class SnakeMovementComponent: LoveComponent {
    var speed: Double
    var direction: SnakeDirection {
        didSet {
            lastDirection = oldValue
        }
    }
    var lastDirection: SnakeDirection
    var movementTimer: LoveUtils.Timer
    
    init(speed: Double = 10.0, direction: SnakeDirection = .idle) {
        self.speed = speed
        self.direction = direction
        self.lastDirection = direction
        self.movementTimer = LoveUtils.Timer(interval: 1/speed)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SnakeMovementComponent {
    enum SnakeDirection {
        case up
        case left
        case right
        case down
        case idle
    }
}
