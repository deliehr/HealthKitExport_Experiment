//
//  HealthKitExport_ExperimentApp.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 05.11.25.
//

import SwiftUI
import SwiftData

@main
struct HealthKitExport_ExperimentApp: App {
    init() {
        UserDefaults.standard.set(Date(), forKey: "dateTo")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
