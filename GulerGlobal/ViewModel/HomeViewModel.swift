//
//  HomeViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim on 14.12.2025.
//

import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var leftRevenue: Double = 0.0
    @Published var amountRevenue: Double = 0.0
    @Published var totalRevenue: Double = 0.0
    @Published var traking: [Tracking] = []
    @Published var isAnimated: Bool = false
    
    init(totalRevenue: Binding<Double>, leftRevenue: Binding<Double>,) {
        traking.removeAll()
        _totalRevenue = totalRevenue
        self.amountRevenue = self.totalRevenue - self.leftRevenue
        self.traking = [
            Tracking(color: .green.opacity(0.85), value: self.amountRevenue),
            Tracking(color: .red.opacity(0.85), value: self.leftRevenue)
        ]
    }
}
