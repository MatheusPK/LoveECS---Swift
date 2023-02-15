//
//  WallSpawnerSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 15/02/23.
//

import Foundation
import SpriteKit

extension WallSpawnerComponent: LoveSystemProtocol {
    func onAdd(world: LoveWorld?) {}
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {
        if event.type == SnakeEnvironment.EVENTS.FRUIT_SPAWN {
            wallSpawnCount += 1
            guard wallSpawnCount % spawnInterval == 0 else { return }
            guard let wallBodyComponent = entity?.component(ofType: WallSpawnerComponent.self) else { return }
            guard let world = world else { return }
            guard let scene = world.scene else { return }
            
            let wallEntity = LoveEntity(components: [
                LoveSpriteComponent(color: wallBodyComponent.wallColor, size: wallBodyComponent.wallSize, layer: .items),
                ColliderComponent(type: .wall, collidibleTypes: [.all], contactTestTypes: [.all]),
                TypeComponent(type: .wall)
            ])
            
            while true {
                let possibleWallPosition = generateRandomWallPosition(in: scene)
                if !scene.nodes(at: possibleWallPosition).contains(where: { node in
                    return node.entity?.component(ofType: TypeComponent.self)?.type == .snakeHead &&
                           node.entity?.component(ofType: TypeComponent.self)?.type == .snakeBody &&
                           node.entity?.component(ofType: TypeComponent.self)?.type == .wall
                }) {
                    if let fruitSprite = wallEntity.component(ofType: LoveSpriteComponent.self) {
                        fruitSprite.sprite.position = possibleWallPosition
                    }
                    break
                }
            }
            
            world.addEntity(wallEntity)
        }
    }
    
    func process(world: LoveWorld?, dt: TimeInterval) {}
    
    func generateRandomWallPosition(in scene: LoveScene?) -> CGPoint {
        guard let scene = scene else { return .zero }
        let x = CGFloat.random(in: (0 + wallSize.width/2)...(scene.size.width - wallSize.width/2))
        let y = CGFloat.random(in: (0 + wallSize.height/2)...(scene.size.height - wallSize.height/2))
        return CGPoint(x: x, y: y)
    }
}
