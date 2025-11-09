//
//  BaseViewModel.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 09.11.25.
//

import SwiftUI
import HealthKit
import DevTools

class BaseViewModel {
    let healthStore = HealthKitService.shared.store
    
    var dateFrom = Date()
    var dateTo = Date()
    
    var dateFromBinding: Binding<Date> {
        Binding<Date> {
            UserDefaults.standard.object(forKey: "dateFrom") as? Date ?? Date()
        } set: { newDate in
            self.dateFrom = newDate
            
            UserDefaults.standard.set(newDate, forKey: "dateFrom")
        }
    }
    
    var dateToBinding: Binding<Date> {
        Binding<Date> {
            UserDefaults.standard.object(forKey: "dateTo") as? Date ?? Date()
        } set: { newDate in
            self.dateTo = newDate
            
            UserDefaults.standard.set(newDate, forKey: "dateTo")
        }
    }
    
    var queryTimeRangePredicate: NSPredicate {
        HKQuery.predicateForSamples(withStart: dateFrom, end: dateTo, options: [])
    }
    
    init() {
        dateFrom = UserDefaults.standard.object(forKey: "dateFrom") as? Date ?? Date()
    }
}
