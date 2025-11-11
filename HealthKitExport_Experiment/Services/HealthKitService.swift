//
//  HealthKitService.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 08.11.25.
//

import Foundation
import HealthKit
import SwiftUI
import DevTools

typealias HeartRatesContinuation = CheckedContinuation<[HKQuantitySample], Error>
typealias WorkoutsContinuation = CheckedContinuation<[HKWorkout], Error>

@Observable
class HealthKitService {
    static let shared = HealthKitService()
    
    private let healthStore: HKHealthStore
    
    var store: HKHealthStore { healthStore }
    let appSampleTypes: Set<HKSampleType>
    
    var hasAllPermissions: Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        
        for type in appSampleTypes {
            let status = healthStore.authorizationStatus(for: type)
            
            if status != .sharingAuthorized {
                return false
            }
        }
        return true
    }
    
    var permissionsBySampleType: [HKSampleType: Bool] {
        guard HKHealthStore.isHealthDataAvailable() else {
            return Dictionary(uniqueKeysWithValues: appSampleTypes.map { ($0, false) })
        }
        
        var result: [HKSampleType: Bool] = [:]
        
        for type in appSampleTypes {
            let status = healthStore.authorizationStatus(for: type)
            result[type] = (status == .sharingAuthorized)
        }
        
        return result
    }
    
    private var heartRatesContinuation: HeartRatesContinuation?
    private var workoutsContinuation: WorkoutsContinuation?
    
    init() {
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("This app requires a device that supports HealthKit")
        }
        
        healthStore = HKHealthStore()
        
        appSampleTypes = Set([
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.workoutType()
        ])
    }
    
    func requestPermissions() {
        healthStore.requestAuthorization(toShare: nil, read: appSampleTypes) { (success, error) in
            print("Request Authorization -- Success: ", success, " Error: ", error ?? "nil")
        }
    }
    
    func readHeartRate(start: Date, end: Date) async throws -> [HKQuantitySample] {
        let sampleType  = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: createPredicate(start: start, end: end),
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptor],
                                  resultsHandler: handleHeartRatesQueryResult(_:_:_:))
        
        return try await withCheckedThrowingContinuation { (continuation: HeartRatesContinuation) in
            precondition(self.heartRatesContinuation == nil, "heartRatesContinuation already in use")
            self.heartRatesContinuation = continuation
            self.healthStore.execute(query)
        }
    }
    
    func readWorkouts(start: Date, end: Date) async throws -> [HKWorkout] {
        let sampleType = HKObjectType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: createPredicate(start: start, end: end),
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptor],
                                  resultsHandler: handleWorkoutsQueryResult(_:_:_:))
        
        return try await withCheckedThrowingContinuation { (continuation: WorkoutsContinuation) in
            precondition(self.workoutsContinuation == nil, "workoutsContinuation already in use")
            self.workoutsContinuation = continuation
            self.healthStore.execute(query)
        }
    }
    
    nonisolated private func handleHeartRatesQueryResult(_ query: HKSampleQuery, _ results: [HKSample]?, _ error: (any Error)?) {
        Task {
            let continuation = await self.heartRatesContinuation
            await set(heartRatesContinuation: nil)
            
            if let error {
                continuation?.resume(throwing: error)
                return
            }
            
            guard let samples = results as? [HKQuantitySample] else {
                continuation?.resume(returning: [])
                return
            }
            
            continuation?.resume(returning: samples)
        }
    }
    
    nonisolated private func handleWorkoutsQueryResult(_ query: HKSampleQuery, _ results: [HKSample]?, _ error: (any Error)?) {
        Task {
            let continuation = await self.workoutsContinuation
            
            await set(workoutsContinuation: nil)
            
            if let error {
                continuation?.resume(throwing: error)
                return
            }
            
            guard let workouts = results as? [HKWorkout] else {
                continuation?.resume(returning: [])
                return
            }
            
            continuation?.resume(returning: workouts)
        }
    }
    
    private func createPredicate(start: Date, end: Date) -> NSPredicate {
        HKQuery.predicateForSamples(withStart: start, end: end, options: [])
    }
    
    private func set(heartRatesContinuation: HeartRatesContinuation?) {
        self.heartRatesContinuation = heartRatesContinuation
    }
    
    private func set(workoutsContinuation: WorkoutsContinuation?) {
        self.workoutsContinuation = workoutsContinuation
    }
}
