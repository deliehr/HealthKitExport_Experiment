//
//  ViewModel.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 05.11.25.
//

import Foundation
import HealthKit
import DevTools

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
        
        func readHeartRate(){
            let quantityType  = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            
           
            
            let sampleQuery = HKSampleQuery.init(sampleType: quantityType,
                                                 predicate: get24hPredicate(),
                                                 limit: HKObjectQueryNoLimit,
                                                 sortDescriptors: [sortDescriptor],
                                                 resultsHandler: queryResultHandler(_:_:_:))
            
            self.healthStore?.execute(sampleQuery)
        }
        
        func readWorkouts(){
            let workoutType = HKObjectType.workoutType()
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let predicate = get24hPredicate()
            
            let query = HKSampleQuery(sampleType: workoutType,
                                      predicate: predicate,
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: [sortDescriptor]) { [weak self] _, results, error in
                guard let self else { return }
                
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
            
            healthStore?.execute(query)
        }
        
        private func queryResultHandler(_ query: HKSampleQuery, _ results: [HKSample]?, _ error: (any Error)?) {
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
        
        private func get24hPredicate() ->  NSPredicate{
            let predicate = HKQuery.predicateForSamples(withStart: dateFrom, end: dateTo, options: [])
            
            return predicate
        }
    }
}
