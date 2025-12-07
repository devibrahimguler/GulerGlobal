//
//  HomeView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 30.01.2024.
//

import SwiftUI
import Charts

struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HStack() {
                    VStack(alignment: .leading, spacing: 0) {
                        ChartCard(title: "Toplam", description: "\(viewModel.totalRevenue.customDouble())", color: .blue)
                        
                        ChartCard(title: "Alınan", description: "\((viewModel.totalRevenue - viewModel.leftRevenue).customDouble())", color: .green)
                        
                        ChartCard(title: "Kalan", description: "\(viewModel.leftRevenue.customDouble())", color: .red)
                        
                    }
                    .animation(.smooth, value: viewModel.leftRevenue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                    
                    Chart {
                        ForEach(viewModel.traking, id: \.self) { traking in
                            SectorMark(
                                angle: .value("Price", traking.value),
                                innerRadius: .fixed(15),
                                angularInset: 1
                            )
                            .foregroundStyle(traking.color)
                        }
                        
                    }
                    .chartYScale(domain: 0...12000)
                    .frame(height: 170)
                    .padding(5)
                    .overlay {
                        Circle()
                            .stroke(style: .init(lineWidth: 5))
                            .fill(Color.blue.opacity(85))
                    }
                    .padding(5)
                }
                .padding(.horizontal, 10)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30))
                
                Spacer()
            }
            .padding(.horizontal, 10)
        }
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2))
        .onAppear(perform: animateChart)
        .onReceive(viewModel.$leftRevenue) { _ in
            resetChartAnimation()
            animateChart()
        }
    }
    
    private func animateChart() {
        guard !viewModel.isAnimated else { return }
        viewModel.isAnimated = true
        
        $viewModel.traking.enumerated().forEach { index, element in
            if index > 5 {
                element.wrappedValue.isAnimated = true
            } else {
                let delay = Double(index) * 0.05
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.smooth) {
                        element.wrappedValue.isAnimated = true
                    }
                }
            }
        }
    }
    
    private func resetChartAnimation() {
        $viewModel.traking.forEach { traking in
            traking.wrappedValue.isAnimated = false
        }
        
        viewModel.isAnimated = false
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
