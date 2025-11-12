//
//  Array+Point.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik Liehr on 12.11.25.
//

import Foundation
import HealthKit
import DevTools

extension Array<Point> {
    init(_ samples: [HKQuantitySample]) {
        self.init()
        
        for (i,sample) in samples.enumerated() {
//            let mSample = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            
            let device = sample.device
            
            let value = sample.quantity.doubleValue(for: .count().unitDivided(by: .minute()))
            
            let value2 = sample.quantity.doubleValue(for: .count().unitDivided(by: .second()))
            
            let startDate = sample.startDate.asString("HH:mm:ss.SSS")
            let endDate = sample.endDate.asString("HH:mm:ss.SSS")
            
            let meta = sample.metadata
            let source = sample.sourceRevision
            
            self.append(Point(id: i, date: sample.startDate, value: value))
        }
    }
}
