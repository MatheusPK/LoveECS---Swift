//
//  TitanItemSpawnerSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 15/02/23.
//

import Foundation
import SpriteKit

extension TitanItemSpawnerComponent: LoveSystemProtocol {
    func onAdd(world: LoveWorld?) {}
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {
        switch event.type {
        case SnakeEnvironment.EVENTS.SPAWN_TITAN_ITEM:
            guard let titanBodyComponent = entity?.component(ofType: TitanItemSpawnerComponent.self) else { return }
            guard let world = world else { return }
            guard let scene = world.scene else { return }
            
            let itemEntity = LoveEntity(components: [
                LoveSpriteComponent(color: titanBodyComponent.itemColor, size: titanBodyComponent.itemSize, layer: .items),
                ColliderComponent(type:.titanItem , collidibleTypes: [.none], contactTestTypes: [.snakeHead]),
                TypeComponent(type: .titanItem)
            ])
            
            while true {
                let possibleItemPosition = generateRandomItemPosition(in: scene)
                if !scene.nodes(at: possibleItemPosition).contains(where: { node in
                    return node.entity?.component(ofType: TypeComponent.self)?.type == .snakeHead &&
                    node.entity?.component(ofType: TypeComponent.self)?.type == .snakeBody &&
                    node.entity?.component(ofType: TypeComponent.self)?.type == .wall
                }) {
                    if let itemSprite = itemEntity.component(ofType: LoveSpriteComponent.self) {
                        itemSprite.sprite.position = possibleItemPosition
                    }
                    break
                }
            }
            shouldSpawn = false
            world.addEntity(itemEntity)
        case SnakeEnvironment.EVENTS.END_TITAN_EVENT:
            shouldSpawn = true
        default:
            break
        }
        
    }
    
    func process(world: LoveWorld?, dt: TimeInterval) {
        if shouldSpawn && itemSpawnTimer.fired(dt, speed: spawnInterval) {
            world?.enqueueEvent(event: LoveEvent(type: SnakeEnvironment.EVENTS.SPAWN_TITAN_ITEM))
        }
    }
    
    func generateRandomItemPosition(in scene: LoveScene?) -> CGPoint {
        guard let scene = scene else { return .zero }
        let x = CGFloat.random(in: (0 + itemSize.width/2)...(scene.size.width - itemSize.width/2))
        let y = CGFloat.random(in: (0 + itemSize.height/2)...(scene.size.height - itemSize.height/2))
        return CGPoint(x: x, y: y)
    }
}

