//
//  CompanyDetails.swift
//  GulerGlobal
//
//  Created by ibrahim on 14.12.2025.
//

import Foundation

struct CompanyDetails {
    var name: String = ""
    var address: String = ""
    var phone: String = ""
    var status: CompanyStatus = .current
    
    init() {}
    
    init(from company: Company?) {
        name = company?.name ?? ""
        address = company?.address ?? ""
        phone = company?.phone ?? ""
        status = company?.status ?? .current
    }
}
