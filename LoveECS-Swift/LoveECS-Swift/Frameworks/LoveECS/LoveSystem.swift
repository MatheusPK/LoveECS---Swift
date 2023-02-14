//
//  LoveSystem.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation
import GameplayKit

protocol LoveSystemProtocol {
    func onAdd(world: LoveWorld?)
    func handleEvent(world: LoveWorld?, event: LoveEvent, dt: TimeInterval)
    func process(world: LoveWorld?, dt: TimeInterval)
}

class LoveSystem: GKComponentSystem<GKComponent> {
    weak var world: LoveWorld?
    var observableEvents = [String]()
    var identifier: String
    
    init(world: LoveWorld?, observableEvents: [String], componentClass: AnyClass, identifier: String? = nil) {
        self.world = world
        self.observableEvents = observableEvents
        self.identifier = identifier ?? "\(componentClass)"
        super.init(componentClass: componentClass)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let events = getEvents()
        for componentSystem in components {
            if let componentSystem = componentSystem as? LoveSystemProtocol {
                processEvents(for: componentSystem, events: events, dt: seconds)
                componentSystem.process(world: world, dt: seconds)
            }
        }
    }
    
    private func processEvents(for componentSystem: LoveSystemProtocol, events: [LoveEvent], dt: TimeInterval) {
        for event in events {
            componentSystem.handleEvent(world: world, event: event, dt: dt)
        }
    }
    
    private func getEvents() -> [LoveEvent] {
        var events = [LoveEvent]()
        observableEvents.forEach { eventType in
            events.append(contentsOf: world?.dequeueEvent(eventType: eventType) ?? [])
        }
        
        return events
    }
    
    func onAdd() {
        for componentSystem in components {
            if let componentSystem = componentSystem as? LoveSystemProtocol {
                componentSystem.onAdd(world: world)
            }
        }
    }
}
