//
//  ColliderComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 08/02/23.
//
import Foundation
import GameplayKit

class ColliderComponent: LoveComponent {
    
    let type: ColliderType
    var collidibleTypes: [ColliderType]
    var contactTestTypes: [ColliderType]
    var physicsBody: SKPhysicsBody?
    
    init(type: ColliderType, collidibleTypes: [ColliderType], contactTestTypes: [ColliderType], physicsBody: SKPhysicsBody? = nil) {
        self.type = type
        self.collidibleTypes = collidibleTypes
        self.contactTestTypes = contactTestTypes
        self.physicsBody = physicsBody
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        setupBitMask()
    }
    
    private func setupBitMask() {
        guard let spriteComponent = entity?.component(ofType: LoveSpriteComponent.self) else { return }
        let node = spriteComponent.sprite
        let physicsBody = physicsBodyFactory(size: node.size)
        node.physicsBody = physicsBody
    }
    
    private func getCollisionBitMask() -> UInt32 {
        var bitmask: UInt32 = 0x0
        for collidibleType in collidibleTypes {
            bitmask |= collidibleType.getBitMask()
        }
        return bitmask
    }
    
    private func getContactTestBitMask() -> UInt32 {
        var bitmask: UInt32 = 0x0
        for contactTestType in contactTestTypes {
            bitmask |= contactTestType.getBitMask()
        }
        return bitmask
    }
    
    func physicsBodyFactory(size: CGSize) -> SKPhysicsBody {
        let physicsBody = physicsBody ?? SKPhysicsBody(rectangleOf: size)
        physicsBody.categoryBitMask = type.getBitMask()
        physicsBody.collisionBitMask = getCollisionBitMask()
        physicsBody.contactTestBitMask = getContactTestBitMask()
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        return physicsBody
    }
    
}

extension ColliderComponent {
    
    enum ColliderType {
        case snakeHead
        case snakeBody
        case fruit
        case eventItem
        case wall
        case all
        case none
        
        func getBitMask() -> UInt32 {
            switch self {
                case .snakeHead: return 0x1 << 0
                case .snakeBody: return 0x1 << 1
                case .fruit: return 0x1 << 2
                case .eventItem: return 0x1 << 3
                case .wall: return 0x1 << 4
                case .all: return UInt32.max
                case .none: return UInt32.zero
            }
        }
        
    }
    
}

protocol ContactNotifiable {
    func contactDidBegin(with entity: LoveEntity, world: LoveWorld)
    func contactDidEnd(with entity: LoveEntity, world: LoveWorld)
}
