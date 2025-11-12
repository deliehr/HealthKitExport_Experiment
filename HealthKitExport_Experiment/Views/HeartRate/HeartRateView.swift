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
    @State private var isFetching = false
    @State private var chartFetches = [ChartFetch]()
    @State private var fetchTask: Task<Void,Error>?
    
    var body: some View {
        Form {
            Section("Range") {
                DatePicker("Von", selection: viewModel.dateFromBinding)
                DatePicker("Bis", selection: viewModel.dateToBinding)
                
                HStack {
                    Button {
                        fetchHeartRateData()
                    } label: {
                        Text("Fetch")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if isFetching {
                        ProgressView()
                    }
                }
                
                if !chartFetches.isEmpty {
                    Button(role: .destructive) {
                        chartFetches.removeAll()
                    } label: {
                        Text("Reset")
                    }
                }
            }
            .disabled(isFetching)
            
            ForEach(chartFetches) { chartFetch in
                HeartRateChartSectionView(chartFetch: chartFetch)
            }
        }
        .onDisappear {
            fetchTask?.cancel()
            fetchTask = nil
        }
    }
    
    private func fetchHeartRateData() {
        fetchTask?.cancel()
        fetchTask = nil
        
        isFetching = true
        
        let dateFrom = viewModel.dateFrom
        let dateTo = viewModel.dateTo
        let index = chartFetches.count
        
        fetchTask = Task { [index, dateFrom, dateTo] in
            defer { isFetching = false }
            
            let time0 = CACurrentMediaTime()
            
            let samples = try await healthKitService.readHeartRate(start: viewModel.dateFrom, end: viewModel.dateTo)
            
            let points = [Point](samples)
            
            let minY = Int(floor(points.min(by: { $0.value < $1.value })?.value ?? 0.0))
            let maxY = Int(ceil(points.max(by: { $0.value < $1.value })?.value ?? 0.0))
            
            let fetch = ChartFetch(id: index,
                                   dateFrom: dateFrom,
                                   dateTo: dateTo,
                                   points: points,
                                   minY: minY,
                                   maxY: maxY)

            
            let time1 = CACurrentMediaTime()
            
            let diff = time1 - time0
            
            if diff < 0.3 {
                let waitTime = (0.3 - diff) * 1000
                
                try? await Task.sleep(for: .milliseconds(waitTime))
            }
            
            try Task.checkCancellation()
            
            self.chartFetches.append(fetch)
        }
    }
}

#Preview {
    HeartRateView()
}
