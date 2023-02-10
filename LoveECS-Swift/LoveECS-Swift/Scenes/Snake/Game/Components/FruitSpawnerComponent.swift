//
//  FruitSpawnerComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 08/02/23.
//

import Foundation
import UIKit

class FruitSpawnerComponent: LoveComponent {
    let fruitSize: CGSize
    let fruitColor: UIColor
    let spawnRate: TimeInterval
    let spawnTimer: LoveUtils.Timer
    
    init(fruitSize: CGSize, fruitColor: UIColor, spawnRate: TimeInterval) {
        self.fruitSize = fruitSize
        self.fruitColor = fruitColor
        self.spawnRate = spawnRate
        self.spawnTimer = LoveUtils.Timer(interval: 1/spawnRate)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
