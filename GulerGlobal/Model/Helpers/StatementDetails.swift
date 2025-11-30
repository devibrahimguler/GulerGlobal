//
//  StatementDetails.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 22.10.2025.
//

import SwiftUI

// MARK: - Supporting Models

struct StatementDetails {
    var amount: String = ""
    var date: Date = .now
    
    init() {}
    
    init(from statement: Statement?) {
        amount = "\(statement?.amount ?? 0)"
        date = statement?.date ?? .now
    }
}
