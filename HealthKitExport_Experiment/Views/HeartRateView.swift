//
//  HeartRateView.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 08.11.25.
//

import SwiftUI
import HealthKit
import DevTools
import Charts

struct HeartRateView: View {
    @State private var vm = ViewModel()
    
    var body: some View {
        Form {
            Section("Range") {
                DatePicker("Von", selection: vm.dateFromBinding)
                DatePicker("Bis", selection: vm.dateToBinding)
                
                Button("Request") {
                    vm.readHeartRate()
                }
            }
            
            if !vm.heartRateData.isEmpty {
                Section("Chart (\(vm.heartRateData.count))") {
                    Chart(vm.heartRateData) { point in
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
                    
                    if let minimum = vm.minimum {
                        Text("Minimum: \(Int(minimum.value)), \(minimum.date.asString("dd.MM.yy HH:mm:ss"))")
                    }
                    
                    if let maximum = vm.maximum {
                        Text("Maximum: \(Int(maximum.value)), \(maximum.date.asString("dd.MM.yy HH:mm:ss"))")
                    }
                    
                    Text("Average: \(Int(vm.average))")
                }
            }
        }
    }
}

#Preview {
    HeartRateView()
}
