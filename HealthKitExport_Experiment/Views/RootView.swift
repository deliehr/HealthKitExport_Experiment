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
                HeartRateView()
            }
            
            Tab("Workouts", systemImage: "figure.run.circle.fill") {
                Text("B")
            }
            
            Tab("Settings", systemImage: "gear.circle.fill") {
                SettingsView()
            }
        }
    }
}

#Preview {
    RootView()
}
