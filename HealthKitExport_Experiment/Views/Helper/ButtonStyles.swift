//
//  ButtonStyles.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 15.11.25.
//

import SwiftUI

struct AddCompareButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    private var foregroundStyle: Color {
        colorScheme == .light ? .black : .white
    }
    
    private var background: Color {
        colorScheme == .light ? Color(.systemGray5) : Color(.systemGray3)
    }
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .font(.system(size: 14))
            .foregroundStyle(foregroundStyle)
            .padding(4)
            .background(background)
            .clipShape(.rect(cornerRadius: 4))
    }
}

#Preview("default") {
    Button("+ Compare") {
        
    }
    .buttonStyle(AddCompareButtonStyle())
}

#Preview("section header - light") {
    Form {
        Section {
            Text("test")
        } header: {
            HStack {
                Text("Bla")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("+ Compare") {
                    
                }
                .buttonStyle(AddCompareButtonStyle())
            }
        }
    }
}

#Preview("section header - dark") {
    Form {
        Section {
            Text("test")
        } header: {
            HStack {
                Text("Bla")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("+ Compare") {
                    
                }
                .buttonStyle(AddCompareButtonStyle())
            }
        }
    }
    .preferredColorScheme(.dark)
}

extension ButtonStyle where Self == AddCompareButtonStyle {
    var addCompare: AddCompareButtonStyle {
        AddCompareButtonStyle()
    }
}
