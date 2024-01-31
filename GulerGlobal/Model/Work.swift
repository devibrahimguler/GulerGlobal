//
//  Work.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import Foundation

struct Work {
    var id: UUID = UUID()
    
    var pNum: String
    var name: String
    var desc: String
    var price: Double
    var accept: Accept?
}
