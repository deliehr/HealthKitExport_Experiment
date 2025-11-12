//
//  ViewModel.swift
//  HealthKitExport_Experiment
//
//  Created by Dominik on 08.11.25.
//

import SwiftUI
import HealthKit
import DevTools

extension HeartRateView {
    @Observable
    class ViewModel {
        var heartRateData = [Point]()
        
        public private(set) var dateFrom = Date()
        public private(set) var dateTo = Date()

        var dateFromBinding: Binding<Date> {
            Binding<Date> {
                UserDefaults.standard.object(forKey: "hrDateFrom") as? Date ?? Date()
            } set: { newDate in
                self.dateFrom = newDate
                
                UserDefaults.standard.set(newDate, forKey: "hrDateFrom")
            }
        }

        var dateToBinding: Binding<Date> {
            Binding<Date> {
                UserDefaults.standard.object(forKey: "hrDateTo") as? Date ?? Date()
            } set: { newDate in
                self.dateTo = newDate
                
                UserDefaults.standard.set(newDate, forKey: "hrDateTo")
            }
        }
        
        init() {
            dateFrom = UserDefaults.standard.object(forKey: "dateFrom") as? Date ?? Date()
        }
    }
}
