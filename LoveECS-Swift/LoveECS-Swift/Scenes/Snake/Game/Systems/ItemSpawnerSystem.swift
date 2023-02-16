//
//  ItemSpawnerSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 15/02/23.
//

import Foundation

extension ItemSpawnerComponent: LoveSystemProtocol {
    func onAdd(world: LoveWorld?) {
        onAdd?()
    }
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {
        guard let spawnEvents = spawnEvents else { return }
        for type in spawnEvents {
            if event.type == type {
                spawnItem(world: world)
            }
        }
    }
    
    func process(world: LoveWorld?, dt: TimeInterval) {
        guard let spawnTimer = spawnTimer, let spawnInterval = spawnInterval else { return }
        if spawnTimer.fired(dt, speed: spawnInterval) && !onlyTriggerSpawnByEvents {
            spawnItem(world: world)
        }
    }
    
    private func spawnItem(world: LoveWorld?) {
        guard let world = world else { return }
        guard let scene = world.scene else { return }
        
        let itemEntity = LoveEntity(components: itemComponents.map({$0.copy() as! LoveComponent}))
        
        while true {
            guard let spawnPosition = generateRandomItemPosition(for: itemEntity, scene: scene) else { return }
            let nodes = scene.nodes(at: spawnPosition)
            let hasEntityInSpawnPosition = nodes.contains(where: { node in
                guard let entityType = node.entity?.component(ofType: TypeComponent.self)?.type else { return false }
                return (self.notOverlaps.firstIndex(of: entityType) == nil)
            })
            if !hasEntityInSpawnPosition {
                itemEntity.component(ofType: LoveSpriteComponent.self)?.sprite.position = spawnPosition
                break
            }
        }
        
        world.addEntity(itemEntity)
    }
    
    func generateRandomItemPosition(for entity: LoveEntity, scene: LoveScene) -> CGPoint? {
        guard let spriteComponent = entity.component(ofType: LoveSpriteComponent.self) else { return nil }
        let spriteSize = spriteComponent.sprite.size
        let x = CGFloat.random(in: (0 + spriteSize.width/2)...(scene.size.width - spriteSize.width/2))
        let y = CGFloat.random(in: (0 + spriteSize.height/2)...(scene.size.height - spriteSize.height/2))
        return CGPoint(x: x, y: y)
    }
    
    
}
