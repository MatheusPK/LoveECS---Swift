//
//  SceneFactory.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation
import UIKit

protocol SceneFactory {
    associatedtype Dependencies
    static func make(with dependencies: Dependencies) -> UIViewController
}
