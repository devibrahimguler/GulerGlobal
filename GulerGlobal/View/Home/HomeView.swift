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
                        InfoBadge(
                            title: "Toplam",
                            description: viewModel.totalRevenue.customDouble(),
                            color: .blue
                        )
                        
                        InfoBadge(
                            title: "Alınan",
                            description: viewModel.amountRevenue.customDouble(),
                            color: .green
                        )
                        
                        InfoBadge(
                            title: "Kalan",
                            description: viewModel.leftRevenue.customDouble(),
                            color: .red
                        )
                        
                    }
                    .animation(.smooth, value: viewModel.leftRevenue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                    
                    Chart {
                        ForEach(viewModel.chartData, id: \.self) { data in
                            SectorMark(
                                angle: .value("Price", data.isAnimated ? data.value : 0.0),
                                innerRadius: .fixed(15),
                                angularInset: 1
                            )
                            .foregroundStyle(data.color)
                            .opacity(data.isAnimated ? 1.0 : 0.0)
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
        
        $viewModel.chartData.enumerated().forEach { index, element in
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
        $viewModel.chartData.forEach { traking in
            traking.wrappedValue.isAnimated = false
        }
        
        viewModel.isAnimated = false
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
