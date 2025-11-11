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
    class ViewModel {
        var heartRateData = [Point]()
        
        var dateFrom = Date()
        var dateTo = Date()

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
        
        init() {
            dateFrom = UserDefaults.standard.object(forKey: "dateFrom") as? Date ?? Date()
        }
        
        func set(heartRateSamples samples: [HKQuantitySample]) {
            var newData = [Point]()
            
            for (i,sample) in samples.reversed().enumerated() {
    //            let mSample = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                
                let device = sample.device
                
                let value = sample.quantity.doubleValue(for: .count().unitDivided(by: .minute()))
                
                let value2 = sample.quantity.doubleValue(for: .count().unitDivided(by: .second()))
                
                let startDate = sample.startDate.asString("HH:mm:ss.SSS")
                let endDate = sample.endDate.asString("HH:mm:ss.SSS")
                
                let meta = sample.metadata
                let source = sample.sourceRevision
                
                newData.append(Point(id: i, date: sample.startDate, value: value))
            }
            
            let min = newData.min { p0, p1 in
                p0.value < p1.value
            }
            
            let max = newData.max { p0, p1 in
                p0.value < p1.value
            }
            
            self.minY = Int(min?.value ?? 0.0)
            self.maxY = Int(max?.value ?? 200.0)
            
            heartRateData.removeAll()
            heartRateData = newData
        }
    }
}
