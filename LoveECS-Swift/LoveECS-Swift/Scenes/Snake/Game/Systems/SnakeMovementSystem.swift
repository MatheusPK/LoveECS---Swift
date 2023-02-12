//
//  SnakeMovementSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 07/02/23.
//

import Foundation
import SpriteKit

extension SnakeMovementComponent: LoveSystemProtocol {
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {
        if event.type == SnakeEvents.fruitHit.key() {
            guard let snakeBodyComponent = entity?.component(ofType: SnakeBodyComponent.self) else { return }
            snakeBodyComponent.shouldIncreaseBodySize = true
//            let newNode = snakeBodyComponent.createNewNode()
//            let newEntity = LoveEntity(components: [
//                LoveSpriteComponent(sprite: newNode, layer: .player),
//                //                TextureComponent(texture: SKTexture(imageNamed: "iconeTriangulo"))
//            ])
//            world?.addEntity(newEntity)
//            world?.enqueueEvent(event: LoveEvent(type: SnakeEvents.fruitSpawn.key()))
        } else if event.type == SnakeEvents.createSnakeBody.key() {
            guard let snakeBodyComponent = entity?.component(ofType: SnakeBodyComponent.self) else { return }
            let body = snakeBodyComponent.createBody()
            for node in body {
                let entity = LoveEntity(components: [
                    LoveSpriteComponent(sprite: node, layer: .player),
                    //                    TextureComponent(texture: SKTexture(imageNamed: "iconeTriangulo"))
                ])
                world?.addEntity(entity)
            }
            snakeBodyComponent.body = body
        }
    }
    
    func process(world: LoveWorld?, dt: TimeInterval) {
        guard let snakeBodyComponent = entity?.component(ofType: SnakeBodyComponent.self) else { return }
        guard let snakeMovementComponent = entity?.component(ofType: SnakeMovementComponent.self) else { return }
        
        var lastSnakeHeadPosition = snakeBodyComponent.head.position
        let snakeHead = snakeBodyComponent.head
        let snakeNodeSize = snakeBodyComponent.nodeSize
        let snakeBodyOffset = snakeBodyComponent.bodyOffset
        
        if snakeMovementComponent.movementTimer.fired(dt) {
            
            var movement = CGPoint(x: 0, y: 0)
            
            switch snakeMovementComponent.direction {
            case .up:
                movement.y += snakeNodeSize.height + snakeBodyOffset
            case .left:
                movement.x -= snakeNodeSize.width + snakeBodyOffset
            case .right:
                movement.x += snakeNodeSize.width + snakeBodyOffset
            case .down:
                movement.y -= snakeNodeSize.height + snakeBodyOffset
            case .idle:
                return
            }
            
            movement = getMovementOffset(movement: movement, lastPosition: lastSnakeHeadPosition, newPosition: (snakeHead.position + movement), bounds: world?.scene?.size ?? .zero, nodeSize: snakeNodeSize)
            
//             movimento titan
//                        snakeHead.run(.move(to: CGPoint(x: lastSnakeHeadPosition.x + newVectorMove.dx, y: lastSnakeHeadPosition.y + newVectorMove.dy), duration: 1/speed))
//                        for i in 0..<snakeBodyComponent.body.count {
//                            let node = snakeBodyComponent.body[i]
//                            let auxPosition = node.position
//                            node.run(.move(to: lastSnakeHeadPosition, duration: 1/self.speed))
//                            lastSnakeHeadPosition = auxPosition
//                        }
            
//             movimento classico
            snakeHead.position += movement
            for i in 0..<snakeBodyComponent.body.count {
                let node = snakeBodyComponent.body[i]
                let auxPosition = node.position
                node.position = lastSnakeHeadPosition
                lastSnakeHeadPosition = auxPosition
            }
            
            snakeBodyComponent.snakeHeadLastPosition = lastSnakeHeadPosition
            
            if snakeBodyComponent.shouldIncreaseBodySize {
                let sprite = SKSpriteNode(color: .systemPink, size: snakeNodeSize)
                sprite.position = lastSnakeHeadPosition
                let newEntity = LoveEntity(components: [
                    LoveSpriteComponent(sprite: sprite, layer: .player),
                ])
                snakeBodyComponent.body.append(sprite)
                world?.addEntity(newEntity)
                world?.enqueueEvent(event: LoveEvent(type: SnakeEvents.fruitSpawn.key()))
                snakeBodyComponent.shouldIncreaseBodySize = false
            }
        }
        
    }
    
    func onAdd(world: LoveWorld?) {
        world?.enqueueEvent(event: LoveEvent(type: SnakeEvents.createSnakeBody.key()))
    }
    
    func getMovementOffset(movement: CGPoint, lastPosition: CGPoint, newPosition: CGPoint, bounds: CGSize, nodeSize: CGSize) -> CGPoint {
        
        var moveOffset = movement
        
        if newPosition.x > bounds.width {
            moveOffset.x = bounds.width - lastPosition.x - nodeSize.width/2
        } else if newPosition.x < 0 {
            moveOffset.x = 0 - lastPosition.x + nodeSize.width/2
        } else if newPosition.y > bounds.height {
            moveOffset.y = bounds.height - lastPosition.y - nodeSize.height/2
        } else if newPosition.y < 0 {
            moveOffset.y = 0 - lastPosition.y + nodeSize.height/2
        }
        
        return moveOffset

    }
    
}
