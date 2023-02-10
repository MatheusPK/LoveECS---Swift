//
//  SnakeGameScene.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation
import GameplayKit


class SnakeGameScene: LoveScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        let faceTrackingView = loveDependencies[SnakeDependencies.faceTrackingView.key()] as! FaceTrackingView
        
        let bakcgroundEntity = LoveEntity(components: [
            LoveSpriteComponent(color: .clear, size: view.frame.size, position: CGPoint(x: size.width/2, y: size.height/2), layer: .background),
            TextureComponent(texture: SKTexture(imageNamed: "fundo"))
        ])
        
        let snakeEntity = LoveEntity(components: [
            SnakeBodyComponent(nodeSize: CGSize(width: 30, height: 30), bodyOffset: 0, initialBodySize: 0, initialPosition: CGPoint(x: size.width/2, y: size.height/2)),
            SnakeMovementComponent(speed: 10, direction: .idle),
            FaceTrackingMovementComponent(faceTrackingView: faceTrackingView),
            SnakeColliderComponent(type: .snake, collidibleTypes: [.fruit], contactTestTypes: [.all]),
//            TextureComponent(texture: .init(imageNamed: "caveira"))
        ])

        let fruitEntity = LoveEntity(components: [
            FruitSpawnerComponent(fruitSize: CGSize(width: 30, height: 30), fruitColor: .systemPink, spawnRate: 1),
        ])

        let snakeMovementSystem = LoveSystem(world: world, observableEvents: [SnakeEvents.fruitHit.key(), SnakeEvents.createSnakeBody.key()], componentClass: SnakeMovementComponent.self)
        let fruitSpawnerSystem = LoveSystem(world: world, observableEvents: [SnakeEvents.fruitSpawn.key()], componentClass: FruitSpawnerComponent.self)

        world.addEntity(bakcgroundEntity)
        world.addEntity(snakeEntity)
        world.addEntity(fruitEntity)

        world.addSystem(snakeMovementSystem)
        world.addSystem(fruitSpawnerSystem)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let delta: TimeInterval = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        world.update(dt: delta)
    }
}


// MARK: - SKPhysicsContactDelegate
extension SnakeGameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let entityA = contact.bodyA.node?.entity else { return }
        guard let entityB = contact.bodyB.node?.entity else { return }
        
        guard let entityAColliderComponent = entityA.component(ofType: SnakeColliderComponent.self) else { return }
        guard let entityBColliderComponent = entityB.component(ofType: ColliderComponent.self) else { return }
        
        if entityAColliderComponent.type == .snake && entityBColliderComponent.type == .fruit {
            world.enqueueEvent(event: LoveEvent(type: SnakeEvents.fruitHit.key()))
            world.removeEntity(entityB as! LoveEntity)
        } else if entityAColliderComponent.type == .fruit && entityBColliderComponent.type == .snake {
            world.enqueueEvent(event: LoveEvent(type: SnakeEvents.fruitHit.key()))
            world.removeEntity(entityA as! LoveEntity)
        }
    }
}
