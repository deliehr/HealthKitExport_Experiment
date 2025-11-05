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
        private var healthStore: HKHealthStore?
        
        var data = [Point]()
        var minY = Int.max
        var maxY = Int.min
        var dateFrom = Date()
        var dateTo = Date()
        var workouts: [HKWorkout] = []
        
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
        
        private var queryTimeRangePredicate: NSPredicate {
            HKQuery.predicateForSamples(withStart: dateFrom, end: dateTo, options: [])
        }
        
        init() {
            guard HKHealthStore.isHealthDataAvailable() else {
                fatalError("This app requires a device that supports HealthKit")
            }
            
            healthStore = HKHealthStore()
        }
        
        func requestHealthkitPermissions() {
            let sampleTypesToRead = Set([
                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
                HKObjectType.workoutType()
            ])
            
            healthStore?.requestAuthorization(toShare: nil, read: sampleTypesToRead) { (success, error) in
                print("Request Authorization -- Success: ", success, " Error: ", error ?? "nil")
            }
        }
        
        func readHeartRate() {
            let sampleType  = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            
            let sampleQuery = HKSampleQuery.init(sampleType: sampleType,
                                                 predicate: queryTimeRangePredicate,
                                                 limit: HKObjectQueryNoLimit,
                                                 sortDescriptors: [sortDescriptor],
                                                 resultsHandler: handleHeartRateQueryResult(_:_:_:))
            
            self.healthStore?.execute(sampleQuery)
        }
        
        func readWorkouts() {
            let sampleType = HKObjectType.workoutType()
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            
            let query = HKSampleQuery(sampleType: sampleType,
                                      predicate: queryTimeRangePredicate,
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: [sortDescriptor],
                                      resultsHandler: handleWorkoutsQueryResult(_:_:_:))
            
            healthStore?.execute(query)
        }
        
        private func handleHeartRateQueryResult(_ query: HKSampleQuery, _ results: [HKSample]?, _ error: (any Error)?) {
            guard let samples = results as? [HKQuantitySample] else {
                print(error!)
                return
            }
            
            var newData = [Point]()
            
            var productTypes = Set<String>()
            var productTypesNames = Set<String>()
            var sources = Set<HKSourceRevision>()
            
            for (i,sample) in samples.reversed().enumerated() {
    //            let mSample = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                
                let device = sample.device
                
                let value = sample.quantity.doubleValue(for: .count().unitDivided(by: .minute()))
                
                let value2 = sample.quantity.doubleValue(for: .count().unitDivided(by: .second()))
                
                let startDate = sample.startDate.asString("HH:mm:ss.SSS")
                let endDate = sample.endDate.asString("HH:mm:ss.SSS")
                
                let meta = sample.metadata
                let source = sample.sourceRevision
                
                if let productType = source.productType {
                    productTypes.insert(productType)
                }
                
                productTypesNames.insert(source.source.name)
                sources.insert(source)
                
                newData.append(Point(id: i, date: sample.startDate, value: value))
            }
            
            data.removeAll()
            
            let min = newData.min { p0, p1 in
                p0.value < p1.value
            }
            
            let max = newData.max { p0, p1 in
                p0.value < p1.value
            }
            
            self.minY = Int(min?.value ?? 0.0)
            self.maxY = Int(max?.value ?? 200.0)
            
            DispatchQueue.main.async {
                self.data = newData
            }
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
            
            DispatchQueue.main.async {
                self.workouts = workouts
            }
        }
    }
}
