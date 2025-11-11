//
//  SettingsView.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 08.11.25.
//

import SwiftUI
import HealthKit

struct SettingsView: View {
    @Environment(HealthKitService.self) private var healthKitService
    
    var body: some View {
        Form {
            Section("Permissions") {
                if healthKitService.hasAllPermissions {
                    Text("Alle Berechtigungen erteilt")
                } else {
                    Button {
                        healthKitService.requestPermissions()
                    } label: {
                        Text("Request HealthKit Permissions")
                    }
                }
            }
        }
        .onAppear {
            print(healthKitService.permissionsBySampleType)
        }
    }
    
    
}

#Preview {
    SettingsView()
}
