//
//  WallSpawnerSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 15/02/23.
//

import Foundation
import SpriteKit

extension WallSpawnerComponent: LoveSystemProtocol {
    func onAdd(world: LoveWorld?) {}
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {
        switch event.type {
        case SnakeEnvironment.EVENTS.FRUIT_HIT:
            wallSpawnCount += 1
        default:
            break
        }
    }
    
    func process(world: LoveWorld?, dt: TimeInterval) {
        if wallSpawnCount != 0, wallSpawnCount % spawnRate == 0 {
            world?.enqueueEvent(event: LoveEvent.init(type: SnakeEnvironment.EVENTS.WALL_SPAWN))
            wallSpawnCount = 0
        }
    }
}
