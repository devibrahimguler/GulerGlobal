//
//  Company.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import SwiftUI

struct Company: Codable, Hashable, Identifiable {
    var id: String
    var companyName: String
    var companyAddress: String
    var contactNumber: String
    var workList: [Work]
}

struct TupleModel: Hashable, Identifiable {
    let id: String = UUID().uuidString
    let company: Company
    let work: Work
}
