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
            entity?.component(ofType: SnakeBodyComponent.self)?.setSnakePositionToLastSavedPosition()
        case SnakeEnvironment.EVENTS.FRUIT_HIT:
            speed += 1
        case SnakeEnvironment.EVENTS.WALL_HIT:
            direction = .idle
            entity?.component(ofType: SnakeBodyComponent.self)?.setSnakePositionToLastSavedPosition()
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
            
            snakeBodyComponent.saveLastSnakePosition()
            
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
}
