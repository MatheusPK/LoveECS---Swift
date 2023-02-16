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
            guard let sprite = itemEntity.component(ofType: LoveSpriteComponent.self)?.sprite else { return }
            sprite.position = spawnPosition
            var isValidPositon: Bool = true
            
            for entity in world.entities {
                if let otherSprite = entity.component(ofType: LoveSpriteComponent.self)?.sprite {
                    if sprite.intersects(otherSprite), sprite.zPosition == otherSprite.zPosition {
                        isValidPositon = false
                    }
                }
            }
            
            if isValidPositon { break }
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
