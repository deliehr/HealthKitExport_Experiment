//
//  SettingsView.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 08.11.25.
//

import SwiftUI
import HealthKit

struct SettingsView: View {
    private let healthStore = HealthKitService.shared.store
    
    var body: some View {
        Form {
            Section("Permissions") {
                Button {
                    requestHealthkitPermissions()
                } label: {
                    Text("Request HealthKit Permissions")
                }
            }
        }
    }
    
    private func requestHealthkitPermissions() {
        let sampleTypesToRead = Set([
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.workoutType()
        ])
        
        healthStore.requestAuthorization(toShare: nil, read: sampleTypesToRead) { (success, error) in
            print("Request Authorization -- Success: ", success, " Error: ", error ?? "nil")
        }
    }
}

#Preview {
    SettingsView()
}
