//
//  TypeComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 13/02/23.
//

import Foundation

class TypeComponent: LoveComponent {
    let type: EntityType
    
    enum EntityType: CaseIterable {
        case snakeHead
        case snakeBody
        case fruit
        case brick
        case wall
        case titanItem
    }
    
    init(type: EntityType) {
        self.type = type
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = TypeComponent(type: type)
        return copy
    }
}
