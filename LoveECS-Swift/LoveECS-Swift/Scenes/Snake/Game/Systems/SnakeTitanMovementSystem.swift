//
//  SnakeTitanMovementSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 15/02/23.
//

import Foundation
import SpriteKit

extension SnakeTitanMovementComponent: LoveSystemProtocol {
    func onAdd(world: LoveWorld?) {}
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {
        switch event.type {
        case SnakeEnvironment.EVENTS.FRUIT_HIT:
            guard let snakeMovementComponent = entity?.component(ofType: SnakeMovementComponent.self) else { return }
            snakeMovementComponent.speed += 1
        case SnakeEnvironment.EVENTS.END_TITAN_EVENT:
            world?.removeSystem(by: "\(SnakeTitanMovementComponent.self)")
            world?.addSystem(LoveSystem(world: world, observableEvents: [SnakeEnvironment.EVENTS.SNAKE_BODY_HIT, SnakeEnvironment.EVENTS.FRUIT_HIT, SnakeEnvironment.EVENTS.WALL_HIT, SnakeEnvironment.EVENTS.SNAKE_TITAN], componentClass: SnakeMovementComponent.self))
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
        
        let newPosition = snakeHeadPosition + movement
        snakeHead.run(.move(to: newPosition, duration: 1/snakeMovementComponent.speed))
        for i in 0..<snakeBodyComponent.body.count {
            let node = snakeBodyComponent.body[i]
            let auxPosition = node.position
            node.run(.move(to: snakeHeadPosition, duration: 1/snakeMovementComponent.speed))
            snakeHeadPosition = auxPosition
        }
        
        
        snakeBodyComponent.lastSnakeHeadPosition = snakeHeadPosition
    }
}
