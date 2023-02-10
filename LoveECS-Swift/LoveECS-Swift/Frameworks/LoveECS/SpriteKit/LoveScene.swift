//
//  LoveScene.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation
import SpriteKit

class LoveScene: SKScene, SKPhysicsContactDelegate {
    let world: LoveWorld
    
    var lastUpdateTime: TimeInterval = .zero
    
    var loveDependencies = [String:LoveSceneDependency]()
    
    init(world: LoveWorld, size: CGSize) {
        self.world = world
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
    }
    
    func addNode(_ entity: LoveEntity) {
        if let spriteComponent = entity.component(ofType: LoveSpriteComponent.self) {
            addChild(spriteComponent.sprite)
        }
    }
    
    func removeNode(_ entity: LoveEntity) {
        if let spriteComponent = entity.component(ofType: LoveSpriteComponent.self) {
            spriteComponent.sprite.removeAllChildren()
            spriteComponent.sprite.removeFromParent()
        }
    }
}

protocol LoveSceneDependency {}
