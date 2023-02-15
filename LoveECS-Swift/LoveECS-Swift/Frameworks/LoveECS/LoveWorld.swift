//
//  LoveWorld.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 06/02/23.
//

import Foundation
import GameplayKit

class LoveWorld {
    
    typealias EventType = String
    
    var scene: LoveScene?
    
    var entities = Set<LoveEntity>()
    var entitiesToAdd = [LoveEntity]()
    var entitiesToRemove = [LoveEntity]()
    
    var systems = [LoveSystem]()
    var systemsToAdd  = [LoveSystem]()
    var systemsToRemove  = [String]()
    
    var eventQueue = [EventType:[LoveEvent]]()
    var eventsToAdd = [LoveEvent]()
    var eventsToRemove = [EventType]()
    
    // MARK: - Debug properties
    var numberOfEnititesAdded: Int = 0
    var numberOfEntitiesRemoved: Int = 0
    
    var numberOfSystemsAdded: Int = 0
    var numberOfSystemsRemoved: Int = 0
    var systemLoop: [String] = []
    
    var numberOfEventsAdded: Int = 0
    var numberOfEventsRemoved: Int = 0
    var eventQueueDebug: [String:[LoveEvent]] = [:]
    
    var entityCount: Int = 0
    var systemCount: Int = 0
    var eventCount: Int = 0
    
    // MARK: - World Life Cycle
    func update(dt: TimeInterval) {
        manageEntities()
        manageSystems()
        manageEvents()
        #if DEBUG
        manageDebug()
        #endif
        
        clear()
        
        for system in systems {
            system.update(deltaTime: dt)
        }
    }
    
    private func clear() {
        entitiesToAdd.removeAll()
        entitiesToRemove.removeAll()
        systemsToAdd.removeAll()
        systemsToRemove.removeAll()
        eventsToRemove.removeAll()
        eventsToAdd.removeAll()
    }
}

// MARK: - Systems Management
extension LoveWorld {
    
    func addSystem(_ system: LoveSystem) {
        systemsToAdd.append(system)
    }
      
     func removeSystem(by systemIdentifier: String) {
        systemsToRemove.append(systemIdentifier)
    }
    
    private func addComponents(in system: LoveSystem) {
        for entity in entities {
            system.addComponent(foundIn: entity)
        }
    }
    
    private func removeComponents(in system: LoveSystem) {
        for entity in entitiesToRemove {
            system.removeComponent(foundIn: entity)
        }
    }
    
    private func manageSystems() {
        for systemToAdd in systemsToAdd {
            systems.append(systemToAdd)
            addComponents(in: systemToAdd)
            systemToAdd.onAdd()
        }
        
        for systemToRemoveIdentifier in systemsToRemove {
            if let systemToRemoveIndex = systems.firstIndex(where: {
                $0.identifier == systemToRemoveIdentifier
            }) {
                let systemToRemove = systems.remove(at: systemToRemoveIndex)
                removeComponents(in: systemToRemove)
            }
        }
    }
}

// MARK: - Entities Management
extension LoveWorld {
    func addEntity(_ entity: LoveEntity) {
        entitiesToAdd.append(entity)
    }
    
    func removeEntity(_ entity: LoveEntity) {
        entitiesToRemove.append(entity)
    }
    
    private func manageEntities() {
        for entityToAdd in entitiesToAdd {
            entities.insert(entityToAdd)
            scene?.addNode(entityToAdd)
        }
        
        for entityToRemove in entitiesToRemove {
            entities.remove(entityToRemove)
            scene?.removeNode(entityToRemove)
        }
    }
}

// MARK: - Events Management
extension LoveWorld {
    func manageEvents() {
        
        for eventToAdd in eventsToAdd {
            if eventQueue[eventToAdd.type] == nil { eventQueue[eventToAdd.type] = [] }
            eventQueue[eventToAdd.type]?.append(eventToAdd)
        }
        
        for eventTypeToRemove in eventsToRemove {
            eventQueue[eventTypeToRemove] = []
        }
    }
    
    func scheduleEvent(event: LoveEvent, time: TimeInterval) {
        Timer.scheduledTimer(withTimeInterval: time, repeats: false) {_ in
            self.enqueueEvent(event: event)
        }
    }
    
    func enqueueEvent(event: LoveEvent) {
        eventsToAdd.append(event)
    }

    func dequeueEvent(eventType: EventType) -> [LoveEvent] {
        let events = eventQueue[eventType] ?? []
        if !events.isEmpty { eventsToRemove.append(eventType) }
        return events
    }
}

// MARK: - Debug Management
extension LoveWorld {
    func manageDebug() {
        let debugData = LoveDebug(
            numberOfEnititesAdded: entitiesToAdd.count,
            numberOfEntitiesRemoved: entitiesToRemove.count,
            entityCount: entities.count,
            numberOfSystemsAdded: systemsToAdd.count,
            numberOfSystemsRemoved: systemsToRemove.count,
            systemCount: systems.count,
            systemLoop: systems,
            numberOfEventsAdded: eventsToAdd.count,
            numberOfEventsRemoved: eventsToRemove.count,
            eventQueue: eventQueue
        )
        debugData.log()
    }
}

