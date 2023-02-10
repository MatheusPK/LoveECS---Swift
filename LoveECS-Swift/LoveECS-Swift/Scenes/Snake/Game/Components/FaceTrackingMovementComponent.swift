//
//  FaceTrackingMovementComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 07/02/23.
//

import Foundation
import ARKit

class FaceTrackingMovementComponent: LoveComponent {
    let faceTrackingView: FaceTrackingView
    let faceExpressionSet: FaceExpressionSet
    
    var moveSet: FaceExpressionsToDirection
    
    init(faceTrackingView: FaceTrackingView = FaceTrackingView(), faceExpressionSet: FaceExpressionSet = .original) {
        self.faceTrackingView = faceTrackingView
        self.faceExpressionSet = faceExpressionSet
        self.moveSet = faceExpressionSet.getMovementSet()
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        faceTrackingView.startSession()
        faceTrackingView.session.delegate = self
    }
}

extension FaceTrackingMovementComponent {
    
    typealias FaceExpressionsToDirection = [SnakeMovementComponent.SnakeDirection : FaceExpression]
    
    enum FaceExpressionSet {
        case original
        case alternative
        case custom(up: FaceExpression,
                    down: FaceExpression,
                    left: FaceExpression,
                    right: FaceExpression)
        
        fileprivate func getMovementSet() -> FaceExpressionsToDirection {
            var movementSet: FaceExpressionsToDirection
            switch self {
                case .original:
                    movementSet = [
                        .up : FaceExpression(expressions: [.browInnerUp], factor: 0.5),
                        .down : FaceExpression(expressions: [.browDownLeft, .browDownRight], factor: 0.3),
                        .left : FaceExpression(expressions: [.mouthRight], factor: 0.4),
                        .right : FaceExpression(expressions: [.mouthLeft], factor: 0.4)
                    ]
                case .alternative:
                    movementSet = [
                        .up : FaceExpression(expressions: [.mouthPucker], factor: 0.4),
                        .down : FaceExpression(expressions: [.tongueOut], factor: 0.4),
                        .left : FaceExpression(expressions: [.eyeBlinkRight], factor: 0.7),
                        .right : FaceExpression(expressions: [.eyeBlinkLeft], factor: 0.7)
                    ]
                case .custom(up: let up, down: let down, left: let left, right: let right):
                    movementSet = [
                        .up : up,
                        .down : down,
                        .left : left,
                        .right : right
                    ]
            }
            return movementSet
        }
        
    }

}

struct FaceExpression {
    
    let expressions: [ARFaceAnchor.BlendShapeLocation]
    let factor : Float
    
    func reachedFactor(faceAnchor: ARFaceAnchor) -> Bool {
        for expression in expressions {
            if getFactor(for: expression, in: faceAnchor) < factor {
                return false
            }
        }
        return true
    }
    
    private func getFactor(for expression: ARFaceAnchor.BlendShapeLocation?, in faceAnchor: ARFaceAnchor) -> Float {
        guard let expression = expression else { return .zero }
        let factor = faceAnchor.blendShapes[expression] as? Float
        return factor ?? .zero
    }
    
}




