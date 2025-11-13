//
//  ChartFetch.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik Liehr on 12.11.25.
//

import Foundation
import SwiftUI

extension HeartRateView {
    struct ChartFetch: Identifiable, Equatable, Hashable {
        let id = UUID()
        let created: Date = Date()
        let dateFrom: Date
        let dateTo: Date
        let points: [Point]
        let minY: Int
        let maxY: Int
        
        var count: Int {
            points.count
        }
        
        var minimum: Point? {
            points.min(by: { $0.value < $1.value })
        }
        
        var maximum: Point? {
            points.max(by: { $0.value < $1.value })
        }
        
        var average: Double {
            guard !points.isEmpty else { return 0.0 }
            
            let sum = points.reduce(0.0) { partialResult, point in
                partialResult + point.value
            }
            
            return sum / Double(points.count)
        }
    }
    
    struct ChartFetchRequest: Identifiable, Equatable {
        let id = UUID()
        let dateFrom: Date
        let dateTo: Date
    }
}
