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
    var status: StatementStatus = .input
    
    init() {}
    
    init(from statement: Statement?) {
        amount = "\(statement?.amount ?? 0)"
        date = statement?.date ?? .now
        status = statement?.status ?? .input
    }
}
