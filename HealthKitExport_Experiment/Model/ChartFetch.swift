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
        let id: Int
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
        
        // hashable
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(dateFrom)
            hasher.combine(dateTo)
            hasher.combine(created)
        }
        
        // equatable
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }
    
    struct ChartFetchRequest: Identifiable, Equatable, Hashable {
        let id: Int
        let created: Date = Date()
        let dateFrom: Date
        let dateTo: Date
        
        // hashable
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(dateFrom)
            hasher.combine(dateTo)
            hasher.combine(created)
        }
        
        // equatable
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }
}
