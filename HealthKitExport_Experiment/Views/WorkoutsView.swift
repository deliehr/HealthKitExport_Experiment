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
        Grid {
            GridRow {
                Text("A")
                
                Text("B")
            }
            
            GridRow {
                Text("C")
                
                Text("D")
            }
        }
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
                summaryView
                
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
