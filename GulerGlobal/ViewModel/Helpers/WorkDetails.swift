//
//  WorkDetails.swift
//  GulerGlobal
//
//  Created by ibrahim on 14.12.2025.
//

import Foundation

struct WorkDetails {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var cost: String = ""
    var left: String = ""
    var status: ApprovalStatus = .pending
    var productList: [CompanyProduct] = []
    var startDate: Date = .now
    var endDate: Date = .now
    var isChangeProjeNumber: Bool = true
    
    init() {}
    
    init(from work: Work?) {
        id = work?.id ?? ""
        name = work?.name ?? ""
        description = work?.description ?? ""
        cost = "\(work?.cost ?? 0)"
        left = "\(work?.left ?? 0)"
        status = work?.status ?? .pending
        startDate = work?.startDate ?? .now
        endDate = work?.endDate ?? .now
    }
}
