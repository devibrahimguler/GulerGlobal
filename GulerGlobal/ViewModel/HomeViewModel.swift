//
//  HomeViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 28.10.2025.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var totalRevenue: Double = 0
    @Published var remainingRevenue: Double = 0
    
    @Published var traking: [Tracking] = []
    @Published var isAnimated: Bool = false
    
    init(totalRevenue: Double, remainingRevenue: Double) {
        self.totalRevenue = totalRevenue
        self.remainingRevenue = remainingRevenue
        
        self.traking = [
            Tracking(id: 0, color: .blue.opacity(0.85), value: totalRevenue),
            Tracking(id: 1, color: .green.opacity(0.85), value: remainingRevenue),
            Tracking(id: 2, color: .red.opacity(0.85), value: totalRevenue - remainingRevenue)
        ]
    }
    
    func animateChart() {
        guard !isAnimated else { return }
        isAnimated = true
        
        for index in traking.indices {
            if index > 5 {
                traking[index].isAnimated = true
            } else {
                let delay = Double(index) * 0.05
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                    guard let self = self else { return }
                    withAnimation(.smooth) {
                        if self.traking.indices.contains(index) {
                            self.traking[index].isAnimated = true
                        }
                    }
                }
            }
        }
    }
    
    func resetChartAnimation() {
        for index in traking.indices {
            traking[index].isAnimated = false
        }
        isAnimated = false
    }
}
