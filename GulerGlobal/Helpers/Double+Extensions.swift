//
//  Double+Extensions.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 15.01.2025.
//

import SwiftUI

extension Double {
    func customDouble() -> String {
        let formatter = NumberFormatter()
        
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "."
        
        return String(formatter.string(from: number) ?? "")
    }
}
