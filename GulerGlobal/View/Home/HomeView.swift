//
//  HomeView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 30.01.2024.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var dataModel: FirebaseDataModel
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack(alignment: .center) {
                    VStack(spacing: 0) {
                        Property(title: "Toplam Para", desc: "\(dataModel.totalPrice.customDouble()) ₺")

                        
                        Property(title: "Alınan Para", desc: "\((dataModel.totalPrice - dataModel.totalRemPrice).customDouble()) ₺", color: .green)
                        
                        Property(title: "Kalan Para", desc: "\(dataModel.totalRemPrice.customDouble()) ₺", color: .red)
                          
                    }
                    .animation(.smooth, value: dataModel.totalRemPrice)
                    
                    PieChart(slices: [(dataModel.totalPrice - dataModel.totalRemPrice, .green),(dataModel.totalRemPrice, .red)])
                        .animation(.smooth, value: dataModel.totalRemPrice)
                        .shadow(color: colorScheme == .dark ? .white : .black ,radius: 5)
                }
                .padding(.horizontal)
                
                TakenProductView()
                    .environmentObject(dataModel)
                
                Spacer()
            }
            .navigationTitle("Haber Ekranı")
            .navigationBarTitleDisplayMode(.inline)
        }
    
        
        
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
