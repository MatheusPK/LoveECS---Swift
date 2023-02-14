//
//  SnakeColliderComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 09/02/23.
//

import Foundation

class SnakeColliderComponent: LoveComponent, ContactNotifiable {
    
    var collisions = [Collision]()
    
    func contactDidBegin(with entity: LoveEntity) {
        guard let typeComponent = entity.component(ofType: TypeComponent.self) else { return }
        switch typeComponent.type {
        case .snakeHead:
            break
        case .snakeBody:
            collisions.append(Collision(type: .snakeBody, entity: entity))
        case .fruit:
            collisions.append(Collision(type: .fruit, entity: entity))
        case .wall:
            print("bati na parede")
        }
    }
    
    func contactDidEnd(with entity: LoveEntity) {}
}

extension SnakeColliderComponent {
    struct Collision {
        let type: TypeComponent.EntityType
        let entity: LoveEntity
    }
}


