//
//  Company.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import SwiftUI

struct Company: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var address: String
    var phone: String
    var works: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case address = "address"
        case phone = "phone"
        case works = "works"
    }
    
}
