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
        
        var sumKilometersString: String {
            let metersSum = workouts.compactMap { $0.totalDistance?.doubleValue(for: .meter()) }.reduce(0, +)
            let km = metersSum / 1000.0
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            let kmString = formatter.string(from: NSNumber(value: km)) ?? String(format: "%.2f", km)
            return "\(kmString) km"
        }
        
        var sumDurationString: String {
            let totalSeconds = workouts.reduce(0.0) { partial, w in
                max(0, w.endDate.timeIntervalSince(w.startDate)) + partial
            }
            // Auf die nächste volle Minute runden wie in WorkoutRowView
            let totalMinutesRounded = Int((totalSeconds / 60.0).rounded())
            let hours = totalMinutesRounded / 60
            let minutes = totalMinutesRounded % 60
            
            if hours > 0 {
                if minutes > 0 {
                    return "\(hours)h \(minutes)m"
                } else {
                    return "\(hours)h"
                }
            } else {
                return "\(totalMinutesRounded)m"
            }
        }
        
        // Anzahl Workouts Indoor
        var indoorCount: Int {
            workouts.filter { $0.isIndoor }.count
        }
        
        // Anzahl Workouts Outdoor
        var outdoorCount: Int {
            workouts.filter { $0.isOutdoor }.count
        }
        
        // MARK: - Queries
        
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
