//
//  WallSpawnerComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 15/02/23.
//

import Foundation
import UIKit

class BrickSpawnerComponent: LoveComponent {
    let spawnRate: Int
    var brickSpawnCount: Int = 0
    
    init(spawnRate: Int) {
        self.spawnRate = spawnRate
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
