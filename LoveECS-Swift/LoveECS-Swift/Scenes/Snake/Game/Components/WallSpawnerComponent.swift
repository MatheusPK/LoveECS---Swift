//
//  WallSpawnerComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 15/02/23.
//

import Foundation
import UIKit

class WallSpawnerComponent: LoveComponent {
    let wallSize: CGSize
    let wallColor: UIColor
    let spawnInterval: Int
    var wallSpawnCount: Int = -1
    
    init(wallSize: CGSize, wallColor: UIColor, spawnInterval: Int) {
        self.wallSize = wallSize
        self.wallColor = wallColor
        self.spawnInterval = spawnInterval
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
