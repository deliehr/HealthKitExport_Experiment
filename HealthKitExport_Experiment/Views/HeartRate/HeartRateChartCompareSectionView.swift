//
//  HeartRateChartCompareSectionView.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik Liehr on 18.11.25.
//

import SwiftUI
import Charts
import DevTools

extension HeartRateView {
    struct HeartRateChartCompareSectionView: View {
        let chartFetches: Array<ChartFetch>
        
        private var minY: Int {
            chartFetches.min(by: { $0.minY < $1.minY })?.minY ?? 0
        }
        
        private var maxY: Int {
            chartFetches.max(by: { $0.maxY < $1.maxY })?.maxY ?? 0
        }
        
        private var maxDurationMinutes: Double {
            chartFetches
                .map { $0.dateTo.timeIntervalSince($0.dateFrom) / 60.0 }
                .max() ?? 0.0
        }
        
        private var headerView: some View {
            Text("Vergleich (\(chartFetches.count) Serien)")
        }
        
        private var contentView: some View {
            Section {
                if chartFetches.isEmpty {
                    Text("Keine Chart Daten verfügbar")
                } else {
                    Chart {
                        ForEach(Array(chartFetches.enumerated()), id: \.element.id) { (index, fetch) in
                            ForEach(fetch.points) { point in
                                LineMark(
                                    x: .value("Minuten seit Start", elapsedMinutes(for: point, in: fetch)),
                                    y: .value("BPM", point.value),
                                    series: .value("Serie", seriesLabel(for: fetch, index: index))
                                )
                                .foregroundStyle(by: .value("Serie", seriesLabel(for: fetch, index: index)))
                                .interpolationMethod(.monotone)
                            }
                        }
                    }
                    .chartXAxis {
                        AxisMarks(position: .bottom) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let minutes = value.as(Double.self) {
                                    Text(formatMinutes(minutes))
                                }
                            }
                        }
                    }
                    .chartXAxisLabel(alignment: .center) {
                        Text("Minuten seit Start")
                    }
                    .chartYAxisLabel(position: .trailing) {
                        Text("BPM")
                    }
                    .chartXScale(domain: 0...maxDurationMinutes)
                    .chartYScale(domain: [minY, maxY])
                    .chartLegend(position: .bottom, alignment: .leading)
                    .frame(height: 240)
                }
            }
        }
        
        private func elapsedMinutes(for point: Point, in fetch: ChartFetch) -> Double {
            point.date.timeIntervalSince(fetch.dateFrom) / 60.0
        }
        
        private func formatMinutes(_ minutes: Double) -> String {
            let totalSeconds = Int(round(minutes * 60))
            let hours = totalSeconds / 3600
            let mins = (totalSeconds % 3600) / 60
            if hours > 0 {
                return "\(hours)h \(mins)m"
            } else {
                return "\(mins)m"
            }
        }
        
        private func seriesLabel(for fetch: ChartFetch, index: Int) -> String {
            let from = fetch.dateFrom.asString("dd.MM.yy HH:mm")
            let to = fetch.dateTo.asString("dd.MM.yy HH:mm")
            return "Serie \(index + 1): \(from) – \(to)"
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
