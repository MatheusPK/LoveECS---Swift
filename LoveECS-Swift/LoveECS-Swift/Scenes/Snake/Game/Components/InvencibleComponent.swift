//
//  InvencibleComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 16/02/23.
//

import Foundation

class InvencibleComponent: LoveComponent {
    var isInvencible: Bool
    let invencibleTo: [TypeComponent.EntityType]
    init(isInvencible: Bool = false, invencibleTo: [TypeComponent.EntityType]) {
        self.isInvencible = isInvencible
        self.invencibleTo = invencibleTo
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
