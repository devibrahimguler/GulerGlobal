//
//  OldPrice.swift
//  GulerGlobal
//
//  Created by ibrahim on 7.12.2025.
//

import SwiftUI

struct OldPrice: Codable, Hashable {
    var id: String = UUID().uuidString
    var price: Double
    var date: Date
    
    func toDictionary() -> [String: Any] {
        return [
            "id": self.id,
            "price": self.price,
            "date": self.date
        ]
    }
}
