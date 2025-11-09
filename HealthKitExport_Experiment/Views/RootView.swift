//
//  RootView.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 08.11.25.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            Tab("Heart rate", systemImage: "bolt.heart.fill") {
                NavigationStack {
                    HeartRateView()
                        .navigationTitle("Heart rate")
                }
            }
            
            Tab("Workouts", systemImage: "figure.run.circle.fill") {
                NavigationStack {
                    WorkoutsView()
                        .navigationTitle("Workouts")
                }
            }
            
            Tab("Settings", systemImage: "gear.circle.fill") {
                NavigationStack {
                    SettingsView()
                        .navigationTitle("Settings")
                }
            }
        }
    }
}

#Preview {
    RootView()
}
