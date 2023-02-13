//
//  SnakeColliderComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 09/02/23.
//

import Foundation

class SnakeColliderComponent: LoveComponent, ContactNotifiable {
    func contactDidBegin(with entity: LoveEntity, world: LoveWorld) {
        guard let typeComponent = entity.component(ofType: TypeComponent.self) else { return }
        switch typeComponent.type {
        case .snakeHead:
            break
        case .snakeBody:
            world.enqueueEvent(event: LoveEvent(type: SnakeEnvironment.EVENTS.SNAKE_BODY_HIT))
        case .fruit:
            world.enqueueEvent(event: LoveEvent(type: SnakeEnvironment.EVENTS.FRUIT_HIT))
            world.removeEntity(entity)
        case .wall:
            print("bati na parede")
        }
    }
    
    func contactDidEnd(with entity: LoveEntity, world: LoveWorld) {}
}

