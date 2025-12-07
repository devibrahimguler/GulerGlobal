//
//  Statement.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI

struct Statement: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var companyId: String
    var amount: Double
    var date: Date
    var status: StatementStatus
}
