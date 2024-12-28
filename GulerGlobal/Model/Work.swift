//
//  Work.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI

struct Work: Identifiable, Codable, Hashable {
    var id: String
    var companyId: String
    var name: String
    var desc: String
    var price: Double
    var approve: String
    var accept: Accept
    var products: [Product]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case companyId = "companyId"
        case name = "name"
        case desc = "desc"
        case price = "price"
        case approve = "approve"
        case accept = "accept"
        case products = "products"
    }
}
