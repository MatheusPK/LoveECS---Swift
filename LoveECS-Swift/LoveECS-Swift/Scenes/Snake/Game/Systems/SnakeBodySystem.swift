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
            let sprite = SKSpriteNode(color: .systemPink, size: nodeSize)
            sprite.position = CGPoint(x: head.position.x - (CGFloat(i + 1) * nodeSize.width) - (CGFloat(i + 1) * bodyOffset), y: head.position.y)
            sprite.zPosition = 0
            let entity = LoveEntity(components: [LoveSpriteComponent(sprite: sprite, layer: .player)])
            body.append(sprite)
            world?.addEntity(entity)
        }
    }
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {
        switch event.type {
        case SnakeEvents.fruitHit.key():
            let sprite = SKSpriteNode(color: .systemPink, size: nodeSize)
            sprite.position = lastSnakeHeadPosition
            let entity = LoveEntity(components: [LoveSpriteComponent(sprite: sprite, layer: .player)])
            body.append(sprite)
            world?.addEntity(entity)
            world?.enqueueEvent(event: LoveEvent(type: SnakeEvents.fruitSpawn.key()))
            break
        default:
            break
        }
    }
    
    func process(world: LoveWorld?, dt: TimeInterval) {}
    
    
}
