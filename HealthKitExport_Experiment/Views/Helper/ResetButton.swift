//
//  ResetButton.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 14.11.25.
//

import SwiftUI

struct ResetButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    let action: () -> Void
    
    private var foregroundStyle: Color {
        colorScheme == .light ? .black : .white
    }
    
    private var background: Color {
        colorScheme == .light ? Color(.systemGray6) : Color(.systemGray3)
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text("Reset")
                .font(.system(size: 14))
                .foregroundStyle(foregroundStyle)
                .padding(4)
                .background(background)
                .clipShape(.rect(cornerRadius: 4))
        }
    }
}

#Preview {
    Form {
        ResetButton { }
    }
}

#Preview {
    Form {
        ResetButton { }
    }
    .preferredColorScheme(.dark)
}
