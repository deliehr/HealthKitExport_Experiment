//
//  WorkoutsView.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 09.11.25.
//

import SwiftUI
import HealthKit
import DevTools

struct WorkoutsView: View {
    @State private var vm = ViewModel()
    
    private var summaryView: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 8, alignment: .leading),
                GridItem(.flexible(), spacing: 8, alignment: .leading),
                GridItem(.flexible(), spacing: 8, alignment: .leading),
                GridItem(.flexible(), spacing: 8, alignment: .leading)
            ],
            alignment: .leading,
            spacing: 8
        ) {
            Text("∑ Strecke")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(vm.sumKilometersString)
                .font(.headline)
            
            Text("∑ Zeit")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(vm.sumDurationString)
                .font(.headline)
            
            Text("# Indoor")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(vm.indoorCount)")
                .font(.headline)
            
            Text("# Outdoor")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(vm.outdoorCount)")
                .font(.headline)
        }
        .padding(.vertical, 4)
    }
    
    var body: some View {
        Form {
            Section("Range") {
                DatePicker("Von", selection: $vm.dateFrom)
                DatePicker("Bis", selection: $vm.dateTo)
                
                Button("Request") {
                    vm.readWorkouts()
                }
            }
            
            if !vm.workouts.isEmpty {
                Section("Summary") {
                    summaryView
                }
                
                Section("Workouts (\(vm.workouts.count))") {
                    ForEach(vm.workouts) { workout in
                        WorkoutRowView(workout: workout)
                    }
                }
            }
        }
    }
}

#Preview {
    WorkoutsView()
}
