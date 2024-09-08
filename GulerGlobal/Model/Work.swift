//
//  Work.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import Foundation

struct Work: Identifiable, Codable, Hashable {
    var id: String
    var workId: String
    var name: String
    var desc: String
    var price: Double
    var approve: String
    var accept: Accept
    var product: [Product]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case workId = "workId"
        case name = "name"
        case desc = "desc"
        case price = "price"
        case approve = "approve"
        case accept = "accept"
        case product = "product"
    }
}
