//
//  Accept.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI

struct Accept: Codable, Hashable {
    var remMoney: Double
    var recList: [Statement]
    var expList: [Statement]
    var start: Date
    var finished: Date
    
    enum CodingKeys: String, CodingKey {
        case remMoney = "remMoney"
        case recList = "recList"
        case expList = "expList"
        case start = "start"
        case finished = "finished"
    }
    
}
