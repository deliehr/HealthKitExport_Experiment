//
//  ResettableDatePicker.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 14.11.25.
//

import SwiftUI

struct ResettableDatePicker: View {
    let title: String
    
    @Binding var selection: Date
    
    @State private var initialDate = Date()
    @State private var didSetInitialDate = false
    
    private var differetDateSelected: Bool {
        selection != initialDate
    }
    
    var body: some View {
        DatePicker(selection: $selection) {
            HStack {
                Text(title)
                
                if differetDateSelected {
                    ResetButton {
                        selection = initialDate
                    }
                }
            }
        }
        .onAppear {
            guard !didSetInitialDate else { return }
            
            didSetInitialDate = true
            
            selection = initialDate
        }
    }
}

#Preview {
    @Previewable @State var selection = Date()
    
    ResettableDatePicker(title: "title", selection: $selection)
}
