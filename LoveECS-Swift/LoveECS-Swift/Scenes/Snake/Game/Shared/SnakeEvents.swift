//
//  SnakeEvents.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 07/02/23.
//

import Foundation

enum SnakeEvents: String {
    case fruitSpawn = "FRUIT_SPAWN"
    case fruitHit = "FRUIT_HIT"
    case createSnakeBody = "CREATE_SNAKE_BODY"
    
    func key() -> String {
        return self.rawValue
    }
}
