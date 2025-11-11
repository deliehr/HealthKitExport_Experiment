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
    @Environment(HealthKitService.self) private var healthKitService
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        Form {
            Section("Range") {
                DatePicker("Von", selection: $viewModel.dateFrom)
                DatePicker("Bis", selection: $viewModel.dateTo)
                
                Button("Request") {
                    fetchWorkouts()
                }
            }
            
            if !viewModel.workouts.isEmpty {
                Section("Summary") {
                    SummaryView()
                        .environment(viewModel)
                }
                
                Section("Workouts (\(viewModel.workouts.count))") {
                    ForEach(viewModel.workouts) { workout in
                        WorkoutRowView(workout: workout)
                    }
                }
            }
        }
    }
    
    private func fetchWorkouts() {
        Task {
            let workouts = try await healthKitService.readWorkouts(start: viewModel.dateFrom, end: viewModel.dateTo)
            
            viewModel.set(workouts: workouts)
        }
    }
}

#Preview {
    WorkoutsView()
}
