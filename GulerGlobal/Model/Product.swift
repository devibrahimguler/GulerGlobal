//
//  Product.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI

struct Product: Codable, Hashable {
    var name: String
    var quantity: Int32
    var price: Double
    var suggestion: String
    var purchased: Date
    var isBought: Bool
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case quantity = "quantity"
        case price = "price"
        case suggestion = "suggestion"
        case purchased = "purchased"
        case isBought = "isBought"
    }
    
}
