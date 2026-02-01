//
//  DateConfig-Extensions.swift
//  GulerGlobal
//
//  Created by ibrahim on 1.02.2026.
//

import Foundation

extension DateConfig {
    func configToDate() -> Date {
        var components = DateComponents()
        components.day = Int(self.selectedDay) ?? 1
        components.month = getMonthIndex(for: self.selectedMonth) ?? 1
        components.year = Int(self.selectedYear) ?? 1
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "tr_TR")
        let date = Calendar.current.date(from: components) ?? .now
        return date
    }
}
