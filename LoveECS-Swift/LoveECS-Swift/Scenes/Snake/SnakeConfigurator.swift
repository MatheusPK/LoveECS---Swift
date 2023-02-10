//
//  SnakeConfigurator.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation
import UIKit

class SnakeConfigurator: SceneFactory {
    struct Dependencies {
        
    }
    
    static func make(with dependencies: Dependencies) -> UIViewController {
        let view = SnakeView()
        
        let gameWorld = LoveWorld()
        
        let gameScene = SnakeGameScene(world: gameWorld, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.75))
        gameWorld.scene = gameScene
        
        gameScene.loveDependencies[SnakeDependencies.faceTrackingView.key()] = view.faceTrackingView
        
        view.gameView.presentScene(gameScene)
        
        let viewController = SnakeViewController(mainView: view)
        
        return viewController
    }
    
}
