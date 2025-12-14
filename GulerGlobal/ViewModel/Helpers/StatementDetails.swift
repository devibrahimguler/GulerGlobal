//
//  StatementDetails.swift
//  GulerGlobal
//
//  Created by ibrahim on 14.12.2025.
//

import Foundation

struct StatementDetails {
    var amount: String = ""
    var date: Date = .now
    
    init() {}
    
    init(from statement: Statement?) {
        amount = "\(statement?.amount ?? 0)"
        date = statement?.date ?? .now
    }
}
