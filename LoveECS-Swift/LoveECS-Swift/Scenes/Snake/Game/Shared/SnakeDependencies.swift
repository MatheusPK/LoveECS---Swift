//
//  SnakeDependencies.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 07/02/23.
//

import Foundation

enum SnakeDependencies: String {
    case faceTrackingView = "FACE_TRACKING_VIEW"
    
    func key() -> String {
        return self.rawValue
    }
}
