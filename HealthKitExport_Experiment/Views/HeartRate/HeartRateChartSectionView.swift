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
        let number: Int
        
        @Binding var jointYMinValue: Int?
        @Binding var jointYMaxValue: Int?
        @Binding var compareFetches: Set<ChartFetch>
        
        private var minY: Int {
            jointYMinValue ?? chartFetch.minY
        }
        
        private var maxY: Int {
            jointYMaxValue ?? chartFetch.maxY
        }
        
        private var chartHasData: Bool {
            chartFetch.count > 0
        }
        
        private var periodText: String {
            chartFetch.dateFrom.durationString(to: chartFetch.dateTo)
        }
        
        private var headerView: some View {
            HStack {
                Text("Chart \(number) (\(chartFetch.count) Datenpunkte)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if chartHasData {
                    Button("+ Vergleich") {
                        compareFetches.insert(chartFetch)
                    }
                    .buttonStyle(AddCompareButtonStyle())
                }
            }
        }
        
        private var contentView: some View {
            Section() {
                HStack {
                    Text(chartFetch.dateFrom.asString("dd.MM.yy HH:mm"))
                    
                    Text("-")
                    
                    Text(chartFetch.dateTo.asString("dd.MM.yy HH:mm"))
                    
                    Text(periodText)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .font(.system(size: 14))
                
                if chartHasData {
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
                    .chartYScale(domain: [minY, maxY])
                    .frame(height: 200)
                    
                    if let minimum = chartFetch.minimum {
                        Text("Minimum: \(Int(minimum.value)), \(minimum.date.asString("dd.MM.yy HH:mm:ss"))")
                    }
                    
                    if let maximum = chartFetch.maximum {
                        Text("Maximum: \(Int(maximum.value)), \(maximum.date.asString("dd.MM.yy HH:mm:ss"))")
                    }
                    
                    Text("Average: \(Int(chartFetch.average))")
                } else {
                    Text("Keine Chart Daten verfügbar")
                }
            }
        }
        
        var body: some View {
            Section {
                contentView
            } header: {
                headerView
            }
        }
    }
}
