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
    
    var isIndoor: Bool {
        let isIndoor = (metadata?["HKIndoorWorkout"] as? NSNumber)?.boolValue == true
        
        return isIndoor
    }
    
    var isOutdoor: Bool {
        !isIndoor
    }
    
    var name: String {
        workoutActivityType.commonName
    }
}
