//
//  CompanyProduct.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI

struct CompanyProduct: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var companyId: String
    var name: String
    var quantity: Double
    var price: Double
    var date: Date
    var oldPrices: [OldPrice]
}
