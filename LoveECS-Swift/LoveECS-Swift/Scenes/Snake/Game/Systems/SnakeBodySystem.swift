//
//  SnakeBodySystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 12/02/23.
//

import Foundation
import SpriteKit

extension SnakeBodyComponent: LoveSystemProtocol {
    func onAdd(world: LoveWorld?) {
        for i in 0..<initialBodySize {
            let entity = createBodyEntity(in: CGPoint(x: head.position.x - (CGFloat(i + 1) * nodeSize.width) - (CGFloat(i + 1) * bodyOffset), y: head.position.y))
            guard let spriteComponent = entity.component(ofType: LoveSpriteComponent.self) else { return }
            body.append(spriteComponent.sprite)
            world?.addEntity(entity)
        }
    }
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {
        switch event.type {
        case SnakeEnvironment.EVENTS.FRUIT_HIT:
            let entity = createBodyEntity(in: lastSnakeHeadPosition)
            guard let spriteComponent = entity.component(ofType: LoveSpriteComponent.self) else { return }
            body.append(spriteComponent.sprite)
            world?.addEntity(entity)
            world?.enqueueEvent(event: LoveEvent(type: SnakeEnvironment.EVENTS.FRUIT_SPAWN))
            break
        default:
            break
        }
    }
    
    func process(world: LoveWorld?, dt: TimeInterval) {}
    
    private func createBodyEntity(in position: CGPoint) -> LoveEntity {
        let sprite = SKSpriteNode(color: .systemPink, size: nodeSize)
        sprite.position = position
        sprite.zPosition = GameLayer.player.rawValue
        let entity = LoveEntity(components: [
            LoveSpriteComponent(sprite: sprite, layer: .player),
            ColliderComponent(type: .snakeBody, collidibleTypes: [], contactTestTypes: [.snakeHead]),
            TypeComponent(type: .snakeBody)
        ])
        return entity
    }
    
    
}
