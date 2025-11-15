//
//  Mockdata.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 15.11.25.
//

import Foundation
import HealthKit

extension [HKQuantitySample] {
    static func createMockData(start: Date, end: Date) -> [HKQuantitySample] {
        guard start < end else { return [] }
        let type = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let unit = HKUnit.count().unitDivided(by: .minute())
        var result: [HKQuantitySample] = []
        let interval: TimeInterval = 300
        var t = start
        while t < end {
            let bpm = Double(Int.random(in: 55...160))
            let quantity = HKQuantity(unit: unit, doubleValue: bpm)
            let sample = HKQuantitySample(type: type, quantity: quantity, start: t, end: t.addingTimeInterval(1))
            result.append(sample)
            t = t.addingTimeInterval(interval)
        }
        return result.sorted { $0.startDate > $1.startDate }
    }
}

extension [HKWorkout] {
    static func createMockData(start: Date, end: Date) -> [HKWorkout] {
        guard start < end else { return [] }
        let activities: [HKWorkoutActivityType] = [.running, .walking, .cycling, .hiking]
        
        let total = Swift.min(5, Swift.max(1, Int((end.timeIntervalSince(start) / 86400.0).rounded())))
        var workouts: [HKWorkout] = []
        for i in 0..<total {
            let fraction = Double(i + 1) / Double(total + 1)
            let wStart = start.addingTimeInterval(fraction * end.timeIntervalSince(start))
            let duration = TimeInterval(Int.random(in: 30...75) * 60)
            let wEnd = Swift.min(wStart.addingTimeInterval(duration), end)
            let activity = activities.randomElement() ?? .running
            let energy = HKQuantity(unit: .kilocalorie(), doubleValue: Double(Int.random(in: 180...700)))
            let distance = HKQuantity(unit: .meter(), doubleValue: Double(Int.random(in: 2000...12000)))
            let workout = HKWorkout(activityType: activity, start: wStart, end: wEnd, workoutEvents: nil, totalEnergyBurned: energy, totalDistance: distance, device: nil, metadata: nil)
            workouts.append(workout)
        }
        return workouts.sorted { $0.startDate > $1.startDate }
    }
}
