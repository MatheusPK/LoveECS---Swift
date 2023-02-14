//
//  LoveDebug.swift
//  LoveECS-Swift
//
//  Created by Matheus P.K on 14/02/23.
//

import Foundation

struct LoveDebug {
    var numberOfEnititesAdded: Int
    var numberOfEntitiesRemoved: Int
    var entityCount: Int
    
    var numberOfSystemsAdded: Int
    var numberOfSystemsRemoved: Int
    var systemCount: Int
    var systemLoop: [LoveSystem]
    
    var numberOfEventsAdded: Int
    var numberOfEventsRemoved: Int
    var eventQueue: [String:[LoveEvent]]
    
    func log() {
        print("============================== LOVE - LOOP - BEGIN ==============================")
        print("Entity Data: ")
        print("-> Number Of Entities Added = \(numberOfEnititesAdded), Number Of Entities Removed = \(numberOfEntitiesRemoved), Entity Count = \(entityCount)\n")
        
        print("System Data: ")
        print("-> Number Of Systems Added = \(numberOfSystemsAdded), Number Of Entities Removed = \(numberOfSystemsRemoved), System Count = \(systemCount)\n")
        
        print("Event Data: ")
        print("-> Number Of Events Added = \(numberOfEventsAdded), Number Of Events Removed = \(numberOfEventsRemoved), Event Count = \(getEventCount())\n")
        
        print("Event Queue: ")
        for (key, value) in eventQueue {
            print("-> Event Type: \(key), Event Count: \(value.count)")
        }
        print("\n")
        
        print("Systems Loop Sequence: ")
        for system in systemLoop {
            print("-> \(system.identifier)")
        }
        print("=============================== LOVE - LOOP - END ===============================")
    }
    
    private func getEventCount() -> Int {
        var count: Int = 0
        for (_, value) in eventQueue {
            count += value.count
        }
        return count
    }
}
