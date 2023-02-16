//
//  SnakeColliderSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 14/02/23.
//

import Foundation

extension SnakeColliderComponent: LoveSystemProtocol {
    func onAdd(world: LoveWorld?) {}
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {}
    
    func process(world: LoveWorld?, dt: TimeInterval) {
        for collision in collisions {
            if let invencibleComponent = entity?.component(ofType: InvencibleComponent.self), invencibleComponent.isInvencible, invencibleComponent.invencibleTo.contains(where: { collision.type == $0 }) { continue }
            switch collision.type {
            case .snakeHead:
                break
            case .snakeBody:
                world?.enqueueEvent(event: LoveEvent(type: SnakeEnvironment.EVENTS.SNAKE_BODY_HIT))
            case .fruit:
                world?.enqueueEvent(event: LoveEvent(type: SnakeEnvironment.EVENTS.FRUIT_HIT))
                world?.removeEntity(collision.entity)
            case .wall:
                world?.enqueueEvent(event: LoveEvent(type: SnakeEnvironment.EVENTS.WALL_HIT))
                break
            case .titanItem:
                world?.enqueueEvent(event: LoveEvent(type: SnakeEnvironment.EVENTS.SNAKE_TITAN))
                world?.removeEntity(collision.entity)
            case .brick:
                world?.enqueueEvent(event: LoveEvent(type: SnakeEnvironment.EVENTS.BRICK_HIT))
            }
        }
        collisions.removeAll()
    }
}
