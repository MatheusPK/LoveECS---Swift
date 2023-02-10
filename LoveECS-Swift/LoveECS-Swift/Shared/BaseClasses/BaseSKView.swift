//
//  BaseSKView.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation
import SpriteKit

class BaseSKView: SKView {
    init() {
        super.init(frame: .zero)
        setupIndicators()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupIndicators() {
        #if DEBUG
        ignoresSiblingOrder = true
        showsFPS = true
        showsNodeCount = true
        showsPhysics = true
        showsFields = true
        #endif
    }
}
