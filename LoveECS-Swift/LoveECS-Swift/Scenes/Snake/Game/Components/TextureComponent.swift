//
//  TextureComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 10/02/23.
//

import Foundation
import SpriteKit

class TextureComponent: LoveComponent {
    let texture: SKTexture
    
    init(texture: SKTexture) {
        self.texture = texture
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        if let spriteComponent = entity?.component(ofType: LoveSpriteComponent.self) {
            spriteComponent.sprite.texture = texture
        }
    }
    
}
