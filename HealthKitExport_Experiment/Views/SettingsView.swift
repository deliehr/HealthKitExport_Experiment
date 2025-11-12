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
    
    @State private var requestingPermission = false
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
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .disabled(requestingPermission)
                        
                        if requestingPermission {
                            ProgressView()
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
            authorizationGranted = nil
            
            print(healthKitService.permissionsBySampleType)
        }
    }
    
    private func requestPermissions() {
        requestingPermission = true
        authorizationGranted = nil
        
        Task {
            do {
                try await healthKitService.requestPermissions()
                
                authorizationGranted = true
            } catch {
                print(error)
                
                authorizationGranted = false
            }
            
            requestingPermission = false
        }
    }
}

#Preview {
    SettingsView()
}
