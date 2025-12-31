//
//  ChartData.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 27.10.2024.
//

import SwiftUI

struct ChartData: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var color: Color
    var value: Double
    
    var isAnimated: Bool = false
}
