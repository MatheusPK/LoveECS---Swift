//
//  CGPoint+Extension.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 12/02/23.
//

import Foundation

extension CGPoint {
    static public func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static public func += (left: inout CGPoint, right: CGPoint) {
      left = left + right
    }
}
