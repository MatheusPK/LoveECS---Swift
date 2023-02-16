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
        
        scaleMode = .aspectFit
        
        let faceTrackingView = loveDependencies[SnakeEnvironment.DEPENDENCIES.FACE_TRACKING_VIEW] as! FaceTrackingView
        

        let backgroundEntity = LoveEntity(components: [
            LoveSpriteComponent(color: .clear, size: size, position: CGPoint(x: size.width/2, y: size.height/2), layer: .background),
            TextureComponent(texture: SKTexture(imageNamed: "fundo")),
            ColliderComponent(type: .wall, collidibleTypes: [.all], contactTestTypes: [.all], physicsBody: SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2), size: CGSize(width: size.width, height: size.height)))),
            TypeComponent(type: .wall)
        ])
        
        let snakeEntity = LoveEntity(components: [
            SnakeBodyComponent(nodeSize: CGSize(width: 20, height: 20), bodyOffset: 5, initialBodySize: 3, initialPosition: CGPoint(x: size.width/2, y: size.height/2)),
            SnakeMovementComponent(speed: 5, direction: .right),
            FaceTrackingMovementComponent(faceTrackingView: faceTrackingView),
            SnakeColliderComponent(),
            InvencibleComponent(isInvencible: false, invencibleTo: [.wall, .snakeBody])
        ])

        let eventEntity = LoveEntity(components: [
            WallSpawnerComponent(spawnRate: 3),
            TitanItemSpawnerComponent(eventDuration: 5, spawnInterval: 10)
        ])
        
        let fruitSpawnerEntity = LoveEntity(components: [
            ItemSpawnerComponent(spawnEvents: [SnakeEnvironment.EVENTS.FRUIT_SPAWN], notOverlaps: TypeComponent.EntityType.allCases, itemComponents: [
                LoveSpriteComponent(color: .systemPink, size: CGSize(width: 20, height: 20), layer: .items),
                ColliderComponent(type: .fruit, collidibleTypes: [.none], contactTestTypes: [.snakeHead]),
                TypeComponent(type: .fruit)
            ], onAdd: {
                self.world.enqueueEvent(event: LoveEvent(type: SnakeEnvironment.EVENTS.FRUIT_SPAWN))
            })
        ])
        
        let wallSpawnerEnity = LoveEntity(components: [
            ItemSpawnerComponent(spawnEvents: [SnakeEnvironment.EVENTS.WALL_SPAWN], notOverlaps: TypeComponent.EntityType.allCases, itemComponents: [
                LoveSpriteComponent(color: .gray, size: CGSize(width: 20, height: 20), layer: .items),
                ColliderComponent(type: .wall, collidibleTypes: [.none], contactTestTypes: [.snakeHead]),
                TypeComponent(type: .wall)
            ])
        ])
        
        let titanEventSpawnerEntity = LoveEntity(components: [
            ItemSpawnerComponent(spawnEvents: [SnakeEnvironment.EVENTS.SPAWN_TITAN_ITEM], notOverlaps: TypeComponent.EntityType.allCases, itemComponents: [
                LoveSpriteComponent(color: .green, size: CGSize(width: 20, height: 20), layer: .items),
                ColliderComponent(type: .titanItem, collidibleTypes: [.none], contactTestTypes: [.snakeHead]),
                TypeComponent(type: .titanItem)
            ])
        ])

        let snakeMovementSystem = LoveSystem(
            world: world,
            observableEvents: [
                SnakeEnvironment.EVENTS.SNAKE_BODY_HIT,
                SnakeEnvironment.EVENTS.FRUIT_HIT,
                SnakeEnvironment.EVENTS.WALL_HIT,
                SnakeEnvironment.EVENTS.SNAKE_TITAN,
            ],
            componentClass: SnakeMovementComponent.self
        )
        
        let snakeBodySystem = LoveSystem(
            world: world,
            observableEvents: [
                SnakeEnvironment.EVENTS.FRUIT_HIT,
                SnakeEnvironment.EVENTS.CREATE_FRUIT_BODY
            ],
            componentClass: SnakeBodyComponent.self
        )
        
        let invencibleSystem = LoveSystem(
            world: world,
            observableEvents: [
                SnakeEnvironment.EVENTS.START_INVENCIBILITY,
                SnakeEnvironment.EVENTS.STOP_INVENCIBILITY
            ],
            componentClass: InvencibleComponent.self
        )
        
        let wallSpawnerSystem = LoveSystem(
            world: world,
            observableEvents: [
                SnakeEnvironment.EVENTS.FRUIT_HIT
            ],
            componentClass: WallSpawnerComponent.self
        )
        
        let titanEventSpawnerSystem = LoveSystem(
            world: world,
            observableEvents: [
                SnakeEnvironment.EVENTS.END_TITAN_EVENT,
                SnakeEnvironment.EVENTS.SNAKE_TITAN
            ],
            componentClass: TitanItemSpawnerComponent.self
        )
        
        let itemSpawnerSystem = LoveSystem(
            world: world,
            observableEvents: [
                SnakeEnvironment.EVENTS.FRUIT_SPAWN,
                SnakeEnvironment.EVENTS.WALL_SPAWN,
                SnakeEnvironment.EVENTS.SPAWN_TITAN_ITEM
            ],
            componentClass: ItemSpawnerComponent.self
        )
        
        let snakeColliderSystem = LoveSystem(
            world: world,
            observableEvents: [],
            componentClass: SnakeColliderComponent.self
        )

        world.addEntity(backgroundEntity)
        world.addEntity(snakeEntity)
        world.addEntity(eventEntity)
        world.addEntity(titanEventSpawnerEntity)
        world.addEntity(wallSpawnerEnity)
        world.addEntity(fruitSpawnerEntity)

        world.addSystem(snakeMovementSystem)
        world.addSystem(snakeBodySystem)
        world.addSystem(titanEventSpawnerSystem)
        world.addSystem(wallSpawnerSystem)
        world.addSystem(itemSpawnerSystem)
        world.addSystem(invencibleSystem)
        world.addSystem(snakeColliderSystem)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
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
            contactNotifiableComponent.contactDidBegin(with: otherEntity)
        }

        if let contactNotifiableComponent = entityB?.component(conformingTo: ContactNotifiable.self), let otherEntity = entityA {
            contactNotifiableComponent.contactDidBegin(with: otherEntity)
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        let entityA = contact.bodyA.node?.entity as? LoveEntity
        let entityB = contact.bodyB.node?.entity as? LoveEntity

        if let contactNotifiableComponent = entityA?.component(conformingTo: ContactNotifiable.self), let otherEntity = entityB {
            contactNotifiableComponent.contactDidEnd(with: otherEntity)
        }

        if let contactNotifiableComponent = entityB?.component(conformingTo: ContactNotifiable.self), let otherEntity = entityA {
            contactNotifiableComponent.contactDidEnd(with: otherEntity)
        }
    }
}
