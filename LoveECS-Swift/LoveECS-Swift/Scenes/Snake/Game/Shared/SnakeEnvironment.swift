//
//  SnakeEnvironment.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 07/02/23.
//

import Foundation

struct SnakeEnvironment {
    struct DEPENDENCIES {
        static let FACE_TRACKING_VIEW = "FACE_TRACKING_VIEW"
    }
    
    struct EVENTS {
        static let FRUIT_SPAWN       = "FRUIT_SPAWN"
        static let FRUIT_HIT         = "FRUIT_HIT"
        static let WALL_HIT          = "WALL_HIT"
        static let SNAKE_BODY_HIT    = "SNAKE_BODY_HIT"
        static let WALL_SPAWN        = "WALL_SPAWN"
        static let CREATE_FRUIT_BODY = "CREATE_FRUIT_BODY"
    }
}
