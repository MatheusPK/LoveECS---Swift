//
//  LoveComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation
import GameplayKit

class LoveComponent: GKComponent {
    override func copy(with zone: NSZone? = nil) -> Any {
        return LoveComponent()
    }
}
