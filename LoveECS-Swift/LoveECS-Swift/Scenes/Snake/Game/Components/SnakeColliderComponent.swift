//
//  SnakeColliderComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 09/02/23.
//

import Foundation

class SnakeColliderComponent: ColliderComponent {
    override func didAddToEntity() {
        super.didAddToEntity()
        guard let snakeBodyComponent = entity?.component(ofType: SnakeBodyComponent.self) else { return }
        for node in snakeBodyComponent.body {
//            node.physicsBody = physicsBodyFactory(size: node.size)
        }
    }
}
