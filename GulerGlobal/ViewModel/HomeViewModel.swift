//
//  HomeViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim on 14.12.2025.
//

import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var leftRevenue: Double = 0.0 {
        didSet { updateTracking() }
    }
    
    @Published var totalRevenue: Double = 0.0 {
        didSet { updateTracking() }
    }
    
    @Published var amountRevenue: Double = 0.0
    @Published var chartData: [ChartData] = []
    @Published var isAnimated: Bool = false
    
    init(totalRevenue: Double, leftRevenue: Double) {
        self.totalRevenue = totalRevenue
        self.leftRevenue = leftRevenue
        
        updateTracking()
    }
    
    private func updateTracking() {
        self.amountRevenue = self.totalRevenue - self.leftRevenue
        
        self.chartData = [
            ChartData(color: .green.opacity(0.85), value: self.amountRevenue),
            ChartData(color: .red.opacity(0.85), value: self.leftRevenue)
        ]
    }
}
