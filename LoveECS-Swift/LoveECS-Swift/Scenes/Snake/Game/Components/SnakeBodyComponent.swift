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
    var snakeHeadLastPosition: CGPoint
    var nodeSize: CGSize
    var bodyOffset: CGFloat
    var initialBodySize: Int
    var shouldIncreaseBodySize: Bool = false
    
    init(nodeSize: CGSize, bodyOffset: CGFloat, initialBodySize: Int = 3, initialPosition: CGPoint) {
        self.head = SKSpriteNode(color: .white, size: nodeSize)
        self.head.position.x = initialPosition.x + nodeSize.width/2
        self.head.position.y = initialPosition.y + nodeSize.height/2
        self.body = [head]
        self.snakeHeadLastPosition = head.position
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
    }
    
    func createBody() -> [SKSpriteNode] {
        var newBody = [SKSpriteNode]()
        for i in 0..<initialBodySize {
            let sprite = SKSpriteNode(color: .systemPink, size: nodeSize)
            sprite.position = CGPoint(x: head.position.x - (CGFloat(i + 1) * nodeSize.width) - (CGFloat(i + 1) * bodyOffset), y: head.position.y)
            sprite.zPosition = 0
            newBody.append(sprite)
        }
        return newBody
    }
    
    func createNewNode() -> SKSpriteNode {
        let sprite = SKSpriteNode(color: .systemPink, size: nodeSize)
        sprite.position = head.position
        body.append(sprite)
        return sprite
    }
    
}
