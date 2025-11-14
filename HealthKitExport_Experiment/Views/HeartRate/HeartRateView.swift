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
    
    @State private var dateFrom = Date()
    @State private var dateTo = Date()
    @State private var isFetching = false
    @State private var requests = [ChartFetchRequest]()
    @State private var fetches = [ChartFetch]()
    
    @State private var jointYMinValue: Int?
    @State private var jointYMaxValue: Int?
    
    var body: some View {
        Form {
            Section("Range") {
                ResettableDatePicker(title: "Von", selection: $dateFrom)
                ResettableDatePicker(title: "Bis", selection: $dateTo)
                
                HStack {
                    Button {
                        addChartFetchRequest()
                    } label: {
                        Text("Fetch")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if isFetching {
                        ProgressView()
                    }
                }
                
                if !fetches.isEmpty {
                    Button(role: .destructive) {
                        reset()
                    } label: {
                        Text("Reset")
                    }
                }
                
                if fetches.count >= 2 {
                    if jointYMinValue == nil {
                        Button("Y-Achsen angleichen") {
                            calculateJointYMinMaxValues()
                        }
                    } else {
                        Button("Y-Achsen Angleichung aufheben") {
                            resetJointYMinMaxValues()
                        }
                    }
                }
            }
            .disabled(isFetching)
            
            ForEach(Array(fetches.enumerated()), id: \.element.id) { (index, chartFetch) in
                HeartRateChartSectionView(chartFetch: chartFetch,
                                          number: index + 1,
                                          jointYMinValue: $jointYMinValue,
                                          jointYMaxValue: $jointYMaxValue)
                    .swipeActions {
                        Button(role: .destructive) {
                            removeChart(at: index)
                        } label: {
                            Text("Delete")
                        }
                    }
            }
        }
        .task(id: requests) {
            guard let lastRequest = requests.last, requests.count != fetches.count else { return }
            
            do {
                try await fetchHeartRateData(by: lastRequest)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func calculateJointYMinMaxValues() {
        guard let min = fetches.min(by: { $0.minY < $1.minY })?.minY,
              let max = fetches.max(by: { $0.maxY < $1.maxY })?.maxY
        else { return }
        
        jointYMinValue = min
        jointYMaxValue = max
    }
    
    private func resetJointYMinMaxValues() {
        jointYMinValue = nil
        jointYMaxValue = nil
    }
    
    private func removeChart(at index: Int) {
        fetches.remove(at: index)
        requests.remove(at: index)
    }
    
    private func reset() {
        requests.removeAll()
        fetches.removeAll()
    }
    
    private func addChartFetchRequest() {
        let dateFrom = dateFrom
        let dateTo = dateTo
        
        requests.append(ChartFetchRequest(dateFrom: dateFrom, dateTo: dateTo))
    }
    
    private func fetchHeartRateData(by request: ChartFetchRequest) async throws {
        defer {
            isFetching = false
        }
        
        isFetching = true
        
        let time0 = CACurrentMediaTime()
        
        let samples = try await healthKitService.readHeartRate(start: request.dateFrom, end: request.dateTo)
        
        let points = [Point](samples)
        
        let minY = Int(floor(points.min(by: { $0.value < $1.value })?.value ?? 0.0))
        let maxY = Int(ceil(points.max(by: { $0.value < $1.value })?.value ?? 0.0))
        
        let fetch = ChartFetch(dateFrom: request.dateFrom,
                               dateTo: request.dateTo,
                               points: points,
                               minY: minY,
                               maxY: maxY)

        
        let time1 = CACurrentMediaTime()
        
        let diff = time1 - time0
        
        if diff < 0.3 {
            let waitTime = (0.3 - diff) * 1000
            
            try? await Task.sleep(for: .milliseconds(waitTime))
        }
        
        do {
            try Task.checkCancellation()
        } catch {
            requests.removeLast()
            
            return
        }
        
        self.fetches.append(fetch)
    }
}

#Preview {
    HeartRateView()
}
