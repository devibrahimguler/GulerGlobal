//
//  Work.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI

struct Work: Identifiable, Codable, Hashable {
    var id: String
    var workName: String
    var workDescription: String
    var totalCost: Double
    var approve: ApprovalStatus
    var remainingBalance: Double
    var statements: [Statement]
    var startDate: Date
    var endDate: Date
    var productList: [Product]
}

enum ApprovalStatus: String, Codable {
    case none = ""
    case pending = "Pending"
    case approved = "Approved"
    case rejected = "Rejected"
    case finished = "Finished"
}
