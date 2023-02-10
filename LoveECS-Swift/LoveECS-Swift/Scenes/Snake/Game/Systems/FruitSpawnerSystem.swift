//
//  FruitSpawnerSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 08/02/23.
//

import Foundation
import SpriteKit

extension FruitSpawnerComponent: LoveSystemProtocol {
    func onAdd(world: LoveWorld?) {
        world?.enqueueEvent(event: LoveEvent(type: SnakeEvents.fruitSpawn.key()))
    }
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {
        if event.type == SnakeEvents.fruitSpawn.key() {
            guard let fruitBodyComponent = entity?.component(ofType: FruitSpawnerComponent.self) else { return }
            guard let world = world else { return }
            guard let scene = world.scene else { return }
            
            let fruitEntity = LoveEntity(components: [
                LoveSpriteComponent(color: fruitBodyComponent.fruitColor, size: fruitBodyComponent.fruitSize, layer: .items),
                ColliderComponent(type: .fruit, collidibleTypes: [.none], contactTestTypes: [.snake]),
//                TextureComponent(texture: SKTexture(imageNamed: "iconeTriangulo"))
            ])

            while true {
                let possibleFruitPosition = generateRandomFruitPosition(in: scene)
                if !scene.nodes(at: possibleFruitPosition).contains(where: {
                    node in return node.entity?.component(ofType: SnakeMovementComponent.self) != nil
                }) {
                    if let fruitSprite = fruitEntity.component(ofType: LoveSpriteComponent.self) {
                        fruitSprite.sprite.position = possibleFruitPosition
                    }
                    break
                }
            }

            world.addEntity(fruitEntity)
        }
    }

func process(world: LoveWorld?, dt: TimeInterval) {}

func generateRandomFruitPosition(in scene: LoveScene?) -> CGPoint {
    guard let scene = scene else { return .zero }
    let x = CGFloat.random(in: (0 + fruitSize.width/2)...(scene.size.width - fruitSize.width/2))
    let y = CGFloat.random(in: (0 + fruitSize.height/2)...(scene.size.height - fruitSize.height/2))
    return CGPoint(x: x, y: y)
}
}
