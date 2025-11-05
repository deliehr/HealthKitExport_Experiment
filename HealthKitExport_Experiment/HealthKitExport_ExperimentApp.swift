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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
