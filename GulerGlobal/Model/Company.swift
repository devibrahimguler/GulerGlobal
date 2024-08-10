//
//  Company.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import Foundation

struct Company: Codable, Hashable {
    var name: String
    var address: String
    var phone: String
    var work: Work
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case address = "address"
        case phone = "phone"
        case work = "work"
    }
    
}
