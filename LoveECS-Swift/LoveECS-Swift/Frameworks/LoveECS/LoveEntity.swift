//
//  LoveEntity.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation
import GameplayKit

class LoveEntity: GKEntity {
    init(components: [LoveComponent]) {
        super.init()
        for component in components {
            addComponent(component)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
