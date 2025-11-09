//
//  ViewModel.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 09.11.25.
//

import Foundation
import HealthKit
import DevTools
import SwiftUI

extension WorkoutsView {
    @Observable
    class ViewModel: BaseViewModel {
        var workouts: [HKWorkout] = []
        
        var heartRateData = [Point]()
        
        var minimum: Point? {
            heartRateData.min(by: { $0.value < $1.value })
        }
        
        var maximum: Point? {
            heartRateData.max(by: { $0.value < $1.value })
        }
        
        var average: Double {
            var sum = heartRateData.reduce(0.0) { partialResult, point in
                partialResult + point.value
            }
            
            return sum / Double(heartRateData.count)
        }
        
        var minY = Int.max
        var maxY = Int.min
        
        func readWorkouts() {
            let sampleType = HKObjectType.workoutType()
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

            let query = HKSampleQuery(sampleType: sampleType,
                                      predicate: queryTimeRangePredicate,
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: [sortDescriptor],
                                      resultsHandler: handleWorkoutsQueryResult(_:_:_:))

            healthStore.execute(query)
        }
        
        private func handleWorkoutsQueryResult(_ query: HKSampleQuery, _ results: [HKSample]?, _ error: (any Error)?) {
            if let error {
                print("readWorkouts error:", error)
                return
            }

            guard let workouts = results as? [HKWorkout] else {
                print("readWorkouts: results cast failed or nil")
                return
            }

            self.workouts = workouts
        }
    }
}
