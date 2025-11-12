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
    class ViewModel {
        var workouts = [HKWorkout]()
        var dateFrom = Date()
        var dateTo = Date()
        var requestHkError: HKError?
        var requstError: Error?
        
        private var _workoutTypes = Set<HKWorkoutActivityType>()
        
        var workoutTypes: [HKWorkoutActivityType] {
            Array(_workoutTypes)
        }
        
        var dateFromBinding: Binding<Date> {
            Binding<Date> {
                UserDefaults.standard.object(forKey: "dateFrom") as? Date ?? Date()
            } set: { newDate in
                self.dateFrom = newDate
                
                UserDefaults.standard.set(newDate, forKey: "dateFrom")
            }
        }

        var dateToBinding: Binding<Date> {
            Binding<Date> {
                UserDefaults.standard.object(forKey: "dateTo") as? Date ?? Date()
            } set: { newDate in
                self.dateTo = newDate
                
                UserDefaults.standard.set(newDate, forKey: "dateTo")
            }
        }

        init() {
            dateFrom = UserDefaults.standard.object(forKey: "dateFrom") as? Date ?? Date()
        }
        
        func set(workouts: [HKWorkout]) {
            self.workouts = workouts
        }
        
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
        
        var indoorCount: Int {
            workouts.filter { $0.isIndoor }.count
        }
        
        var outdoorCount: Int {
            workouts.filter { $0.isOutdoor }.count
        }
        
        
    }
}
