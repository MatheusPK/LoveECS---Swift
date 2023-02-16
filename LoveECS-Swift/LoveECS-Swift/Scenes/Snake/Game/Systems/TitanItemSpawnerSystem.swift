//
//  TitanItemSpawnerSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 15/02/23.
//

import Foundation
import SpriteKit

extension TitanItemSpawnerComponent: LoveSystemProtocol {
    func onAdd(world: LoveWorld?) {}
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {
        switch event.type {
        case SnakeEnvironment.EVENTS.SNAKE_TITAN:
            world?.enqueueEvent(event: LoveEvent(type: SnakeEnvironment.EVENTS.START_INVENCIBILITY))
            world?.scheduleEvent(event: LoveEvent(type: SnakeEnvironment.EVENTS.END_TITAN_EVENT), time: eventDuration)
        case SnakeEnvironment.EVENTS.END_TITAN_EVENT:
            shouldSpawn = true
        default:
            break
        }
        
    }
    
    func process(world: LoveWorld?, dt: TimeInterval) {
        if shouldSpawn && itemSpawnTimer.fired(dt, speed: spawnInterval) {
            world?.enqueueEvent(event: LoveEvent(type: SnakeEnvironment.EVENTS.SPAWN_TITAN_ITEM))
            shouldSpawn = false
        }
    }
}

