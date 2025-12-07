//
//  WorkProduct.swift
//  GulerGlobal
//
//  Created by ibrahim on 7.12.2025.
//

import SwiftUI

struct WorkProduct: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var workId: String
    var productId: String
    var quantity: Double
    var date: Date
}
