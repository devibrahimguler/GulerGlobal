//
//  Work.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI

struct Work: Identifiable, Codable, Hashable {
    var id: String
    var companyId: String
    var name: String
    var description: String
    var cost: Double
    var left: Double
    var status: ApprovalStatus
    var startDate: Date
    var endDate: Date
}
