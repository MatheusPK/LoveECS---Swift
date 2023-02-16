//
//  ItemSpawnerComponent.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 15/02/23.
//

import Foundation

class ItemSpawnerComponent: LoveComponent {
    var spawnInterval: TimeInterval?
    var despawnInterval: TimeInterval?
    var spawnTimer: LoveUtils.Timer?
    var spawnEvents: [String]?
    let onlyTriggerSpawnByEvents: Bool
    let notOverlaps: [TypeComponent.EntityType]
    let itemComponents: [LoveComponent]
    var onAdd: (() -> ())?
    
    init(spawnEvents: [String], notOverlaps: [TypeComponent.EntityType], itemComponents: [LoveComponent], onAdd: (() -> ())? = nil) {
        self.spawnEvents = spawnEvents
        self.notOverlaps = notOverlaps
        self.itemComponents = itemComponents
        self.onAdd = onAdd
        self.onlyTriggerSpawnByEvents = true
        super.init()
    }
    
    init(spawnInterval: TimeInterval, despawnInterval: TimeInterval, notOverlaps: [TypeComponent.EntityType], itemComponents: [LoveComponent], onAdd: (() -> ())? = nil) {
        self.spawnInterval = spawnInterval
        self.despawnInterval = despawnInterval
        self.notOverlaps = notOverlaps
        self.itemComponents = itemComponents
        self.onAdd = onAdd
        self.onlyTriggerSpawnByEvents = false
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
