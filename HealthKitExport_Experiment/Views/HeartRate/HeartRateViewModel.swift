//
//  ViewModel.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 08.11.25.
//

import SwiftUI
import HealthKit
import DevTools

extension HeartRateView {
    @Observable
    class ViewModel: BaseViewModel {
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
        
        
        func readHeartRate() {
            let sampleType  = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            
            let sampleQuery = HKSampleQuery.init(sampleType: sampleType,
                                                 predicate: queryTimeRangePredicate,
                                                 limit: HKObjectQueryNoLimit,
                                                 sortDescriptors: [sortDescriptor],
                                                 resultsHandler: handleHeartRateQueryResult(_:_:_:))
            
            self.healthStore.execute(sampleQuery)
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
            
            heartRateData.removeAll()
            
            let min = newData.min { p0, p1 in
                p0.value < p1.value
            }
            
            let max = newData.max { p0, p1 in
                p0.value < p1.value
            }
            
            self.minY = Int(min?.value ?? 0.0)
            self.maxY = Int(max?.value ?? 200.0)
            
            DispatchQueue.main.async {
                self.heartRateData = newData
            }
        }
    }
}
