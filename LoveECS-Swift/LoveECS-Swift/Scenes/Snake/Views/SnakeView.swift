//
//  SnakeView.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation
import UIKit
import ARKit

class SnakeView: UIView {
    let faceTrackingView: FaceTrackingView = {
        let view = FaceTrackingView()
        return view
    }()
    
    let gameView: BaseSKView = {
        let view = BaseSKView()
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewCode
extension SnakeView: ViewCode {
    func setupComponents() {
        addSubview(faceTrackingView)
        addSubview(gameView)
    }
    
    func setupConstraints() {
        setupFaceTrackingView()
        setupGameView()
    }
    
    private func setupFaceTrackingView() {
        faceTrackingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            faceTrackingView.topAnchor.constraint(equalTo: topAnchor),
            faceTrackingView.leftAnchor.constraint(equalTo: leftAnchor),
            faceTrackingView.rightAnchor.constraint(equalTo: rightAnchor),
            faceTrackingView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.25)
        ])
    }
    
    private func setupGameView() {
        gameView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameView.topAnchor.constraint(equalTo: faceTrackingView.bottomAnchor),
            gameView.leftAnchor.constraint(equalTo: leftAnchor),
            gameView.rightAnchor.constraint(equalTo: rightAnchor),
            gameView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
