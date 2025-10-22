//
//  Statement.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI

struct Statement: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var amount: Double
    var date: Date
    var status: StatementStatus
}

enum StatementStatus: String, Codable {
    case none = ""
    case input = "input"
    case output = "output"
    case debt = "debt"
    case lend = "lend"
}

struct StatementTupleModel: Hashable, Identifiable {
    let id: String = UUID().uuidString
    let companyId: String
    let statement: [Statement]
}
