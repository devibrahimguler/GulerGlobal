//
//  Statement.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import Foundation

struct Statement: Codable, Hashable {
    var date: Date
    var price: Double
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case price = "price"
    }
}
