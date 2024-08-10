//
//  Product.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 21.07.2024.
//

import Foundation

struct Product: Codable, Hashable {
    var name: String
    var quantity: Int
    var suggestion: String
    var purchased: Date
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case quantity = "quantity"
        case suggestion = "suggestion"
        case purchased = "purchased"
    }
    
}
