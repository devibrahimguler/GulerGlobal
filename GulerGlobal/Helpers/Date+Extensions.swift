//
//  Date+Extensions.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.01.2025.
//

import SwiftUI

extension Date {
    func getStringDate(_ style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr")
        formatter.dateStyle = style
        
        return formatter.string(from: self)
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func dateToConfig() -> DateConfig {
        let components = self.get(.day, .month, .year)
        var config = DateConfig(
            selectedDay: "1",
            selectedMonth: getMonthName(for: 1),
            selectedYear: "1"
        )
        if let day = components.day, let month = components.month, let year = components.year {
            config.selectedDay = String(day)
            config.selectedMonth = getMonthName(for: month)
            config.selectedYear = String(year)
        }
        
        return config
    }
}
