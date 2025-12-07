//
//  Company.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import SwiftUI

struct Company: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var address: String
    var phone: String
    var status: CompanyStatus
}
