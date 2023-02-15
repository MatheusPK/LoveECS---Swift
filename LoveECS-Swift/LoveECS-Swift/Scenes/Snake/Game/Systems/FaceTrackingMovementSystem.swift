//
//  FaceTrackingMovementSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 07/02/23.
//

import Foundation
import ARKit

extension FaceTrackingMovementComponent: LoveSystemProtocol, ARSessionDelegate {
    func onAdd(world: LoveWorld?) {}
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {}
    
    func process(world: LoveWorld?, dt: TimeInterval) {}
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }
        handleFaceExpression(faceAnchor: faceAnchor)
    }
    
    private func handleFaceExpression(faceAnchor: ARFaceAnchor) {
        var directions = [SnakeMovementComponent.SnakeDirection]()
        
        for (direction, faceExpression) in moveSet {
            if faceExpression.reachedFactor(faceAnchor: faceAnchor) {
                directions.append(direction)
            }
        }
        
        if let snakeMovementComponent = entity?.component(ofType: SnakeMovementComponent.self) {
            if let direction = directions.last, direction != snakeMovementComponent.direction.reverse() {
                snakeMovementComponent.direction = direction
            }
        }
    }
}
