//
//  WallSpawnerSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 15/02/23.
//

import Foundation
import SpriteKit

extension BrickSpawnerComponent: LoveSystemProtocol {
    func onAdd(world: LoveWorld?) {}
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {
        switch event.type {
        case SnakeEnvironment.EVENTS.FRUIT_HIT:
            brickSpawnCount += 1
        default:
            break
        }
    }
    
    func process(world: LoveWorld?, dt: TimeInterval) {
        if brickSpawnCount != 0, brickSpawnCount % spawnRate == 0 {
            world?.enqueueEvent(event: LoveEvent.init(type: SnakeEnvironment.EVENTS.WALL_SPAWN))
            brickSpawnCount = 0
        }
    }
}
