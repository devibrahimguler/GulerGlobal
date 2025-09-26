//
//  Product.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI

struct Product: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var productName: String
    var quantity: Int
    var unitPrice: Double
    var supplier: String
    var purchased: Date
    var isBought: Bool = false
}
