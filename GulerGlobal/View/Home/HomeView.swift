//
//  HomeView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 30.01.2024.
//

import SwiftUI
import Charts

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                HStack(alignment: .center) {
                    VStack(spacing: 0) {
                        Property(title: "Toplam Para", desc: "\(viewModel.totalPrice.customDouble()) ₺")

                        
                        Property(title: "Alınan Para", desc: "\((viewModel.totalPrice - viewModel.totalRemPrice).customDouble()) ₺", color: .green)
                        
                        Property(title: "Kalan Para", desc: "\(viewModel.totalRemPrice.customDouble()) ₺", color: .red)
                          
                    }
                    .animation(.smooth, value: viewModel.totalRemPrice)

                    Chart {
                        ForEach(viewModel.traking) { traking in
                            SectorMark(
                                angle: .value("Price", traking.isAnimated ? traking.value : 0),
                                         
                                innerRadius: .fixed(15),
                                angularInset: 1)
                         
                        
                            .foregroundStyle(traking.color)
                            
                            .opacity(traking.isAnimated ? 1 : 0)
                            
                        
                        }
                        
                    }
                    .chartYScale(domain: 0...12000)
                    .frame(height: 150)
                    .padding(5)
                     .overlay {
                         RoundedRectangle(cornerRadius: 70, style: .continuous)
                             .stroke(style: .init(lineWidth: 6))
                             .fill(.hWhite)
                             .frame(width: 132, height: 132)
                             .shadow(color: colorScheme == .dark ? .white : .black ,radius: 5)
                     }
                    .padding()
                }
                .padding(.horizontal)
                .background(.background, in: .rect(cornerRadius: 20))
                .padding(.horizontal)
                
                TakenProductView()
                    .environmentObject(viewModel)
                    .padding(.bottom)
                    .background(.background, in: .rect(cornerRadius: 20))
                    .padding([.horizontal])
                
                
                Spacer()
            }
            .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2) )
            .onAppear(perform: animateChart)
            .onReceive(viewModel.$totalRemPrice, perform: { _ in
                resetChartAnimation()
                animateChart()
            })
        .navigationTitle("Haber Ekranı")
            .navigationBarTitleDisplayMode(.inline)
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
