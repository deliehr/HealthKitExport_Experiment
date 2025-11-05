//
//  ContentView.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 05.11.25.
//

import SwiftUI
import HealthKit
import DevTools
import Charts

struct ContentView: View {
    @State private var vm = ViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                DatePicker("Von", selection: $vm.dateFrom)
                DatePicker("Bis", selection: $vm.dateTo)
                
                Button {
                    vm.requestHealthkitPermissions()
                } label: {
                    Text("permission")
                }
                
                Button {
                    vm.readHeartRate()
                } label: {
                    Text("read heart rate")
                }
                
                Button {
                    vm.readWorkouts()
                } label: {
                    Text("read workouts")
                }
                
                Text("#Workouts: \(vm.workouts.count)")
                
                if !vm.workouts.isEmpty {
                    ForEach(vm.workouts) { elem in
                        Text("Workout: \(elem.nameWithIndoor)")
                    }
                }

                Chart(vm.data) { point in
                    LineMark(
                        x: .value("Uhrzeit", point.date),
                        y: .value("BPM", point.value)
                    )
                    .foregroundStyle(Color.yellow)
                }
                .chartXAxisLabel(alignment: .center) {
                    Text("Uhrzeit")
                }
                .chartYAxisLabel(position: .trailing) {
                    Text("BPM")
                }
                .chartYScale(domain: [vm.minY, vm.maxY])
                .frame(height: 200)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
