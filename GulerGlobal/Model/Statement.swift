//
//  Statement.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI

struct Statement: Codable, Hashable {
    var date: Date
    var price: Double
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case price = "price"
    }
}
