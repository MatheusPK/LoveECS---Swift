//
//  FaceTrackingView.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation
import ARKit

class FaceTrackingView: ARSCNView, LoveSceneDependency {
    init() {
        super.init(frame: .zero, options: nil)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    public func startSession(){
        session.run(ARFaceTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
    }
    
    public func pauseSession(){
        session.pause()
    }
}
