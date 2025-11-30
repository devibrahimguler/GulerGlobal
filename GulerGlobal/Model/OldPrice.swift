//
//  OldPrice.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 9.11.2025.
//

import SwiftUI

struct OldPrice: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var price: Double
    var date: Date
}
