//
//  CompanyDetails.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 22.10.2025.
//

import SwiftUI
// MARK: - Supporting Models

struct CompanyDetails {
    var name: String = ""
    var address: String = ""
    var contactNumber: String = ""
    var partnerRole: PartnerRole = .none
    
    init() {}
    
    init(from company: Company?) {
        name = company?.companyName ?? ""
        address = company?.companyAddress ?? ""
        contactNumber = company?.contactNumber ?? ""
        partnerRole = company?.partnerRole ?? .none
    }
}
