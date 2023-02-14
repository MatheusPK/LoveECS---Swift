//
//  SnakeMovementSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 07/02/23.
//

import Foundation
import SpriteKit

extension SnakeMovementComponent: LoveSystemProtocol {
    func onAdd(world: LoveWorld?) {}
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {
        switch event.type {
        case SnakeEnvironment.EVENTS.SNAKE_BODY_HIT:
            direction = .idle
        case SnakeEnvironment.EVENTS.FRUIT_HIT:
            speed += 1
        default:
            break
        }
    }
    
    func process(world: LoveWorld?, dt: TimeInterval) {
        guard let snakeBodyComponent = entity?.component(ofType: SnakeBodyComponent.self) else { return }
        guard let snakeMovementComponent = entity?.component(ofType: SnakeMovementComponent.self) else { return }
        
        var snakeHeadPosition = snakeBodyComponent.head.position
        let snakeHead = snakeBodyComponent.head
        let snakeNodeSize = snakeBodyComponent.nodeSize
        let snakeBodyOffset = snakeBodyComponent.bodyOffset
        
        if snakeMovementComponent.movementTimer.fired(dt, speed: speed) {
            
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

            movement = getMovementOffset(movement: movement, currentPosition: snakeHeadPosition, bounds: world?.scene?.size ?? .zero, nodeSize: snakeNodeSize)
            if hasCollidedWithSnakeBody(world: world, newPosition: snakeHead.position + movement) {
                direction = .idle
                return
            }
            
            //             movimento titan
            //            let newPosition = snakeHeadPosition + movement
            //            snakeHead.run(.move(to: newPosition, duration: 1/speed))
            //            for i in 0..<snakeBodyComponent.body.count {
            //                let node = snakeBodyComponent.body[i]
            //                let auxPosition = node.position
            //                node.run(.move(to: snakeHeadPosition, duration: 1/self.speed))
            //                snakeHeadPosition = auxPosition
            //            }
            
            
            //             movimento classico
            snakeHead.position += movement
            for i in 0..<snakeBodyComponent.body.count {
                let node = snakeBodyComponent.body[i]
                let auxPosition = node.position
                node.position = snakeHeadPosition
                snakeHeadPosition = auxPosition
            }
            
            snakeBodyComponent.lastSnakeHeadPosition = snakeHeadPosition
        }
        
    }
    
    private func getMovementOffset(movement: CGPoint, currentPosition: CGPoint, bounds: CGSize, nodeSize: CGSize) -> CGPoint {
        let newPosition = currentPosition + movement
        var moveOffset = movement
        
        if newPosition.x > bounds.width {
            moveOffset.x = bounds.width - currentPosition.x - nodeSize.width/2
        } else if newPosition.x < 0 {
            moveOffset.x = 0 - currentPosition.x + nodeSize.width/2
        } else if newPosition.y > bounds.height {
            moveOffset.y = bounds.height - currentPosition.y - nodeSize.height/2
        } else if newPosition.y < 0 {
            moveOffset.y = 0 - currentPosition.y + nodeSize.height/2
        }
        
        return moveOffset
        
    }
    
    private func hasCollidedWithSnakeBody(world: LoveWorld?, newPosition: CGPoint) -> Bool {
        if let nodesAtNewPosition = world?.scene?.nodes(at: newPosition) {
            for node in nodesAtNewPosition {
                if let entity = node.entity, entity.component(ofType: TypeComponent.self)?.type == .snakeBody {
                    return true
                }
            }
        }
        return false
    }
    
}
