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
    @Environment(HealthKitService.self) private var healthKitService
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        Form {
            Section("Range") {
                DatePicker("Von", selection: $viewModel.dateFrom)
                DatePicker("Bis", selection: $viewModel.dateTo)
                
                Button("Request") {
                    fetchHeartRateData()
                }
            }
            
            if !viewModel.heartRateData.isEmpty {
                Section("Chart (\(viewModel.heartRateData.count))") {
                    Chart(viewModel.heartRateData) { point in
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
                    .chartYScale(domain: [viewModel.minY, viewModel.maxY])
                    .frame(height: 200)
                    
                    if let minimum = viewModel.minimum {
                        Text("Minimum: \(Int(minimum.value)), \(minimum.date.asString("dd.MM.yy HH:mm:ss"))")
                    }
                    
                    if let maximum = viewModel.maximum {
                        Text("Maximum: \(Int(maximum.value)), \(maximum.date.asString("dd.MM.yy HH:mm:ss"))")
                    }
                    
                    Text("Average: \(Int(viewModel.average))")
                }
            }
        }
    }
    
    private func fetchHeartRateData() {
        Task {
            let samples = try await healthKitService.readHeartRate(start: viewModel.dateFrom, end: viewModel.dateTo)
            
            viewModel.set(heartRateSamples: samples)
        }
    }
}

#Preview {
    HeartRateView()
}
