//
//  WorkDetails.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 22.10.2025.
//

import SwiftUI

// MARK: - Supporting Models

struct WorkDetails {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var remainingBalance: String = ""
    var totalCost: String = ""
    var approve: ApprovalStatus = .none
    var productList: [Product] = []
    var startDate: Date = .now
    var endDate: Date = .now
    var isChangeProjeNumber: Bool = true
    
    init() {}
    
    init(from work: Work?) {
        id = work?.id ?? ""
        name = work?.workName ?? ""
        description = work?.workDescription ?? ""
        remainingBalance = "\(work?.remainingBalance ?? 0)"
        totalCost = "\(work?.totalCost ?? 0)"
        approve = work?.approve ?? .none
        startDate = work?.startDate ?? .now
        endDate = work?.endDate ?? .now
    }
}
