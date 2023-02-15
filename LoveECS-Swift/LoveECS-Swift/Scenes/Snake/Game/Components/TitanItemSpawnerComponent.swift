//
//  TitanItemSpawnerComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 15/02/23.
//

import Foundation
import UIKit

class TitanItemSpawnerComponent: LoveComponent {
    let itemSize: CGSize
    let itemColor: UIColor
    let spawnInterval: TimeInterval
    let itemSpawnTimer: LoveUtils.Timer
    var shouldSpawn: Bool
    
    init(itemSize: CGSize, itemColor: UIColor, spawnInterval: TimeInterval) {
        self.itemSize = itemSize
        self.itemColor = itemColor
        self.spawnInterval = spawnInterval
        self.itemSpawnTimer = LoveUtils.Timer(interval: spawnInterval)
        self.shouldSpawn = true
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
