//
//  InvencibleSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 16/02/23.
//

import Foundation

extension InvencibleComponent: LoveSystemProtocol {
    func onAdd(world: LoveWorld?) {}
    
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval) {
        switch event.type {
        case SnakeEnvironment.EVENTS.START_INVENCIBILITY:
            isInvencible = true
        case SnakeEnvironment.EVENTS.STOP_INVENCIBILITY:
            isInvencible = false
        default:
            break
            
        }
    }
    
    func process(world: LoveWorld?, dt: TimeInterval) {}
    
    
}
