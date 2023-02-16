//
//  SpriteComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation
import SpriteKit

class LoveSpriteComponent: LoveComponent {
    let sprite: SKSpriteNode
    
    init(texture: SKTexture?, size: CGSize, position: CGPoint = CGPoint(x: 0, y: 0), layer: GameLayer) {
        let sprite = SKSpriteNode(texture: nil, color: .clear, size: size)
        sprite.zPosition = layer.rawValue
        sprite.position = position
        sprite.texture = texture
        self.sprite = sprite
        super.init()
    }
    
    init(color: UIColor, size: CGSize, position: CGPoint = CGPoint(x: 0, y: 0), layer: GameLayer) {
        self.sprite = SKSpriteNode(color: color, size: size)
        self.sprite.position = position
        self.sprite.zPosition = layer.rawValue
        super.init()
    }
    
    init(sprite: SKSpriteNode, layer: GameLayer) {
        self.sprite = sprite
        self.sprite.zPosition = layer.rawValue
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = LoveSpriteComponent(sprite: sprite.copy() as! SKSpriteNode, layer: GameLayer(rawValue: sprite.zPosition) ?? .background)
        return copy
    }
    
    override func didAddToEntity() {
        sprite.entity = entity
    }
    
}
