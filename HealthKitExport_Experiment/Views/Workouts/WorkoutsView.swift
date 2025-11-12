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
                DatePicker("Von", selection: viewModel.dateFromBinding)
                DatePicker("Bis", selection: viewModel.dateToBinding)
                
                Button("Request") {
                    fetchWorkouts()
                }
                
                if let hkError = viewModel.requestHkError {
                    Text("Error: \(hkError.localizedDescription)")
                }
                
                if let error = viewModel.requstError {
                    Text("Error: \(error.localizedDescription)")
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
        viewModel.requestHkError = nil
        viewModel.requstError = nil
        
        Task {
            do {
                let workouts = try await healthKitService.readWorkouts(start: viewModel.dateFrom, end: viewModel.dateTo)
                
                viewModel.set(workouts: workouts)
            } catch {
                if let hkError = error as? HKError {
                    viewModel.requestHkError = hkError
                } else {
                    viewModel.requstError = error
                }
            }
        }
    }
}

#Preview {
    WorkoutsView()
}
