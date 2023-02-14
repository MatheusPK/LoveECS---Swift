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
    
    var systems = Set<LoveSystem>()
    var systemsToAdd  = [LoveSystem]()
    var systemsToRemove  = [LoveSystem]()
    
    var eventQueue = [EventType:[LoveEvent]]()
    var eventsToAdd = [LoveEvent]()
    var eventsToRemove = [EventType]()
    
    // MARK: - World Life Cycle
    func update(dt: TimeInterval) {
        manageEntities()
        manageSystems()
        manageEvents()
        
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
    }
}

// MARK: - Systems Management
extension LoveWorld {
    
    func addSystem(_ system: LoveSystem) {
        systemsToAdd.append(system)
    }
      
     func removeSystem(_ system: LoveSystem) {
        systemsToRemove.append(system)
    }
    
    private func addComponents(in system: LoveSystem) {
        for entity in entitiesToAdd {
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
            systems.insert(systemToAdd)
            addComponents(in: systemToAdd)
            systemToAdd.onAdd()
        }
        
        for systemToRemove in systemsToRemove {
            systems.remove(systemToRemove)
            removeComponents(in: systemToRemove)
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
    
    func enqueueEvent(event: LoveEvent) {
        eventsToAdd.append(event)
    }

    func dequeueEvent(eventType: EventType) -> [LoveEvent] {
        let events = eventQueue[eventType] ?? []
        eventsToRemove.append(eventType)
        return events
    }
}

