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
}
