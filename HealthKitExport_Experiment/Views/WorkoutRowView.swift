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
            guard interval >= 0 else { return "–" }
            
            // Auf die nächste volle Minute runden
            let totalMinutesRounded = Int((interval / 60.0).rounded())
            let hours = totalMinutesRounded / 60
            let minutes = totalMinutesRounded % 60
            
            if hours > 0 {
                if minutes > 0 {
                    return "\(hours)h \(minutes)m"
                } else {
                    return "\(hours)h"
                }
            } else {
                return "\(totalMinutesRounded)m"
            }
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
        
        private var workoutName: String {
            workout.isIndoor ? "\(workout.name) (Indoor)" : "\(workout.name) (Outdoor)"
        }
        
        private var iconView: some View {
            let image = switch workout.workoutActivityType {
            case .walking: Image(systemName: "figure.walk.circle.fill")
            case .cycling: workout.isOutdoor ? Image(systemName: "figure.outdoor.cycle.circle.fill") : Image(systemName: "figure.indoor.cycle.circle.fill")
            case .coreTraining: Image(systemName: "figure.core.training.circle.fill")
            default: Image(systemName: "figure.run.circle.fill")
            }
            
            return image
                .resizable()
                .frame(width: 40, height: 40)
        }
    
        private var workoutTypeView: some View {
            VStack {
                Text(workoutName)
                
                HStack {
                    Text(durationText)
                    
                    if workout.isOutdoor {
                        Text(distanceText)
                    }
                }
            }
        }
        
        private var dateView: some View {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            return Text("s")
        }
        
        var body: some View {
            HStack {
                iconView
                
                workoutTypeView
                
                dateView
            }
        }
    }
}
