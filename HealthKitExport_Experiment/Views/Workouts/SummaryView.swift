//
//  SummaryView.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik Liehr on 09.11.25.
//

import SwiftUI

extension WorkoutsView {
    struct SummaryView: View {
        @Environment(WorkoutsView.ViewModel.self) private var vm
        
        var body: some View {
            VStack {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 8, alignment: .leading),
                        GridItem(.flexible(), spacing: 8, alignment: .leading),
                        GridItem(.flexible(), spacing: 8, alignment: .leading),
                        GridItem(.flexible(), spacing: 8, alignment: .leading)
                    ],
                    alignment: .leading,
                    spacing: 8
                ) {
                    Text("∑ Strecke")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(vm.sumKilometersString)
                        .font(.headline)
                    
                    Text("∑ Zeit")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(vm.sumDurationString)
                        .font(.headline)
                    
                    Text("# Indoor")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(vm.indoorCount)")
                        .font(.headline)
                    
                    Text("# Outdoor")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(vm.outdoorCount)")
                        .font(.headline)
                }
                
                ForEach(Array(vm.workoutTypes)) { workoutType in
                    Text(workoutType.commonName)
                }
            }
        }
    }
}
