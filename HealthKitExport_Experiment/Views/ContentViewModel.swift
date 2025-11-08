//
//  ViewModel.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 05.11.25.
//

import Foundation
import HealthKit
import DevTools
import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        
        
        
        init() {
            
            
            
            
            
        }
        
       
        
        
//        
//        func readWorkouts() {
//            let sampleType = HKObjectType.workoutType()
//            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
//            
//            let query = HKSampleQuery(sampleType: sampleType,
//                                      predicate: queryTimeRangePredicate,
//                                      limit: HKObjectQueryNoLimit,
//                                      sortDescriptors: [sortDescriptor],
//                                      resultsHandler: handleWorkoutsQueryResult(_:_:_:))
//            
//            healthStore?.execute(query)
//        }
//        
//        var workouts: [HKWorkout] = []
//        
//        private func handleWorkoutsQueryResult(_ query: HKSampleQuery, _ results: [HKSample]?, _ error: (any Error)?) {
//            if let error {
//                print("readWorkouts error:", error)
//                return
//            }
//            
//            guard let workouts = results as? [HKWorkout] else {
//                print("readWorkouts: results cast failed or nil")
//                return
//            }
//            
//            DispatchQueue.main.async {
//                self.workouts = workouts
//            }
//        }
    }
}
