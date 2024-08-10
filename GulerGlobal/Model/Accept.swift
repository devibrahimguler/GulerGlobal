//
//  Accept.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import Foundation

struct Accept: Codable, Hashable {
    var remMoney: Double
    var isExpiry: Bool
    var recList: [Statement]
    var expList: [Statement]
    var startDate: Date
    var finishDate: Date
    
    enum CodingKeys: String, CodingKey {
        case remMoney = "remMoney"
        case isExpiry = "isExpiry"
        case recList = "recList"
        case expList = "expList"
        case startDate = "startDate"
        case finishDate = "finishDate"
    }
    
}
