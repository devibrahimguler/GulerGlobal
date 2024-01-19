//
//  Work.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import Foundation
import SwiftData

@Model
final class Work {
    var id: UUID = UUID()
    var name: String
    var desc: String
    var price: Double
    var recMoney: Double
    var remMoney: Double
    var stTime: Date
    var fnTime: Date?
    
    init(name: String, desc: String, price: Double, recMoney: Double, remMoney: Double, stTime: Date, fnTime: Date? = nil) {
        self.name = name
        self.desc = desc
        self.price = price
        self.recMoney = recMoney
        self.remMoney = remMoney
        self.stTime = stTime
        self.fnTime = fnTime
    }
}
