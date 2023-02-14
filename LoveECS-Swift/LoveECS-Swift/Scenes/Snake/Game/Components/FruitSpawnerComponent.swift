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
    
    init(fruitSize: CGSize, fruitColor: UIColor) {
        self.fruitSize = fruitSize
        self.fruitColor = fruitColor
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
