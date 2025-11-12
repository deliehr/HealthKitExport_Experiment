//
//  HeartRateChartSectionView.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik Liehr on 12.11.25.
//

import SwiftUI
import Charts
import DevTools

extension HeartRateView {
    struct HeartRateChartSectionView: View {
        let chartFetch: ChartFetch
        
        var body: some View {
            Section("Chart \(chartFetch.id + 1) (\(chartFetch.count))") {
                Chart(chartFetch.points) { point in
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
                .chartYScale(domain: [chartFetch.minY, chartFetch.maxY])
                .frame(height: 200)
                
                if let minimum = chartFetch.minimum {
                    Text("Minimum: \(Int(minimum.value)), \(minimum.date.asString("dd.MM.yy HH:mm:ss"))")
                }
                
                if let maximum = chartFetch.maximum {
                    Text("Maximum: \(Int(maximum.value)), \(maximum.date.asString("dd.MM.yy HH:mm:ss"))")
                }
                
                Text("Average: \(Int(chartFetch.average))")
            }
        }
    }
}
