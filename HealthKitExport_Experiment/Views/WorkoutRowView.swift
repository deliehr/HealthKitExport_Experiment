//
//  WorkoutRowView.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 09.11.25.
//

import SwiftUI
import HealthKit

extension WorkoutsView {
    struct WorkoutRowView: View {
        let workout: HKWorkout
        
        private var durationText: String {
            let interval = workout.endDate.timeIntervalSince(workout.startDate)
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = [.pad]
            return formatter.string(from: interval) ?? "–"
        }
        
        private var distanceText: String {
            guard let quantity = workout.totalDistance else { return "–" }
            let meters = quantity.doubleValue(for: .meter())
            let km = meters / 1000.0
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            let kmString = numberFormatter.string(from: NSNumber(value: km)) ?? String(format: "%.2f", km)
            return "\(kmString) km"
        }
        
        var body: some View {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm" // 24h-Format
            
            return HStack(alignment: .firstTextBaseline, spacing: 12) {
                // Datum + Zeitspanne
                VStack(alignment: .leading, spacing: 2) {
                    Text(dateFormatter.string(from: workout.startDate))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(timeFormatter.string(from: workout.startDate))–\(timeFormatter.string(from: workout.endDate))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(minWidth: 130, alignment: .leading)
                
                // Workout-Name
                Text(workout.name)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer(minLength: 8)
                
                // Dauer
                Text(durationText)
                    .font(.body)
                    .monospacedDigit()
                
                // Distanz
                Text(distanceText)
                    .font(.body)
                    .monospacedDigit()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
