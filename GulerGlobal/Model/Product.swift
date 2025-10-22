//
//  Product.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI

struct Product: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var supplierId: String
    var supplier: String
    var productName: String
    var quantity: Double
    var unitPrice: Double
    var oldPrices: [OldPrice]
    var purchased: Date
}

struct OldPrice: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var price: Double
    var date: Date
}
