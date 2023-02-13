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
        
        let faceTrackingView = loveDependencies[SnakeEnvironment.DEPENDENCIES.FACE_TRACKING_VIEW] as! FaceTrackingView
        

        let backgroundEntity = LoveEntity(components: [
            LoveSpriteComponent(color: .clear, size: size, position: CGPoint(x: size.width/2, y: size.height/2), layer: .background),
            TextureComponent(texture: SKTexture(imageNamed: "fundo")),
            ColliderComponent(type: .wall, collidibleTypes: [.all], contactTestTypes: [.all], physicsBody: SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint(x: size.width/2, y: size.height/2), size: CGSize(width: size.width - 20, height: size.height - 20)))),
            TypeComponent(type: .wall)
        ])
        
        let snakeEntity = LoveEntity(components: [
            SnakeBodyComponent(nodeSize: CGSize(width: 30, height: 30), bodyOffset: 5, initialBodySize: 0, initialPosition: CGPoint(x: size.width/2, y: size.height/2)),
            SnakeMovementComponent(speed: 10, direction: .idle),
            FaceTrackingMovementComponent(faceTrackingView: faceTrackingView),
            SnakeColliderComponent(),
        ])

        let fruitEntity = LoveEntity(components: [
            FruitSpawnerComponent(fruitSize: CGSize(width: 30, height: 30), fruitColor: .systemPink, spawnRate: 1),
        ])

        let snakeMovementSystem = LoveSystem(world: world, observableEvents: [SnakeEnvironment.EVENTS.SNAKE_BODY_HIT], componentClass: SnakeMovementComponent.self)
        let snakeBodySystem = LoveSystem(world: world, observableEvents: [SnakeEnvironment.EVENTS.FRUIT_HIT], componentClass: SnakeBodyComponent.self)
        let fruitSpawnerSystem = LoveSystem(world: world, observableEvents: [SnakeEnvironment.EVENTS.FRUIT_SPAWN], componentClass: FruitSpawnerComponent.self)

        world.addEntity(backgroundEntity)
        world.addEntity(snakeEntity)
        world.addEntity(fruitEntity)

        world.addSystem(snakeMovementSystem)
        world.addSystem(snakeBodySystem)
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
        let entityA = contact.bodyA.node?.entity as? LoveEntity
        let entityB = contact.bodyB.node?.entity as? LoveEntity

        if let contactNotifiableComponent = entityA?.component(conformingTo: ContactNotifiable.self), let otherEntity = entityB {
            contactNotifiableComponent.contactDidBegin(with: otherEntity, world: world)
        }

        if let contactNotifiableComponent = entityB?.component(conformingTo: ContactNotifiable.self), let otherEntity = entityA {
            contactNotifiableComponent.contactDidBegin(with: otherEntity, world: world)
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        let entityA = contact.bodyA.node?.entity as? LoveEntity
        let entityB = contact.bodyB.node?.entity as? LoveEntity

        if let contactNotifiableComponent = entityA?.component(conformingTo: ContactNotifiable.self), let otherEntity = entityB {
            contactNotifiableComponent.contactDidEnd(with: otherEntity, world: world)
        }

        if let contactNotifiableComponent = entityB?.component(conformingTo: ContactNotifiable.self), let otherEntity = entityA {
            contactNotifiableComponent.contactDidEnd(with: otherEntity, world: world)
        }
    }
}
