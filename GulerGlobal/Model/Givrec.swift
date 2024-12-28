//
//  Givrec.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI

struct Givrec: Identifiable, Codable, Hashable {
    var id: String
    var currentId: String
    var price: Double
    var date: Date
    var isRec: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case currentId = "currentId"
        case price = "price"
        case date = "date"
        case isRec = "isRec"
    }
}
