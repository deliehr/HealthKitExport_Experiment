//
//  HKWorkout+name.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 05.11.25.
//

import Foundation
import HealthKit

extension HKWorkout: @retroactive Identifiable {
    public var id: UUID { self.uuid }
    
    var name: String {
        workoutActivityType.commonName
    }
    
    var nameWithIndoor: String {
        let baseName = workoutActivityType.commonName
        let isIndoor = (metadata?["HKIndoorWorkout"] as? NSNumber)?.boolValue == true
        
        return isIndoor ? "\(baseName) (Indoor)" : baseName
    }
    
}
