//
//  SnakeBodyComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 07/02/23.
//

import Foundation
import SpriteKit

class SnakeBodyComponent: LoveComponent {
    var head: SKSpriteNode
    var body: [SKSpriteNode]
    var lastSnakeHeadPosition: CGPoint
    var nodeSize: CGSize
    var bodyOffset: CGFloat
    var initialBodySize: Int
    var lastSnakePosition: [CGPoint]
    
    init(nodeSize: CGSize, bodyOffset: CGFloat, initialBodySize: Int = 3, initialPosition: CGPoint) {
        self.head = SKSpriteNode(color: .white, size: nodeSize)
        self.head.position.x = initialPosition.x - nodeSize.width/2
        self.head.position.y = initialPosition.y - nodeSize.height/2
        self.body = []
        self.lastSnakePosition = [head.position]
        self.lastSnakeHeadPosition = head.position
        self.nodeSize = nodeSize
        self.bodyOffset = bodyOffset
        self.initialBodySize = initialBodySize
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        entity?.addComponent(LoveSpriteComponent(sprite: head, layer: .player))
        entity?.addComponent(ColliderComponent(type: .snakeHead, collidibleTypes: [], contactTestTypes: [.snakeBody, .wall]))
        entity?.addComponent(TypeComponent(type: .snakeHead))
    }
    
    func saveLastSnakePosition() {
        lastSnakePosition = []
        lastSnakePosition.append(head.position)
        for node in body {
            lastSnakePosition.append(node.position)
        }
    }
    
    func setSnakePositionToLastSavedPosition() {
        if !lastSnakePosition.isEmpty, lastSnakePosition.count == body.count + 1 {
            head.position = lastSnakePosition.removeFirst()
            for i in 0..<lastSnakePosition.count {
                body[i].position = lastSnakePosition[i]
            }
        }
    }
    
}
