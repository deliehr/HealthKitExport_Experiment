//
//  HealthKitService.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 08.11.25.
//

import Foundation
import HealthKit

class HealthKitService {
    static var shared = HealthKitService()
    
    let store: HKHealthStore
    
    private init() {
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("This app requires a device that supports HealthKit")
        }
        
        store = HKHealthStore()
    }
}
