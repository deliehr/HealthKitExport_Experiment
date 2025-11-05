//
//  Item.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 05.11.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
