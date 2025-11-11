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
    
    @State private var authorizationGranted: Bool?
    
    var body: some View {
        Form {
            Section("Permissions") {
                if healthKitService.hasAllPermissions {
                    Text("Alle Berechtigungen erteilt")
                } else {
                    Text("Es fehlen Berechtigungen")
                    
                    HStack {
                        Button {
                            requestPermissions()
                        } label: {
                            Text("Request HealthKit Permissions")
                        }
                        
                        if let authorizationGranted {
                            Image(systemName: authorizationGranted ? "checkmark.circle.fill" : "x.circle.fill")
                                .foregroundStyle(authorizationGranted ? .green : .red)
                        }
                    }
                }
            }
        }
        .onAppear {
            print(healthKitService.permissionsBySampleType)
        }
    }
    
    private func requestPermissions() {
        authorizationGranted = nil
        
        Task {
            do {
                try await healthKitService.requestPermissions()
                
                authorizationGranted = true
            } catch {
                print(error)
                
                authorizationGranted = false
            }
        }
    }
}

#Preview {
    SettingsView()
}
