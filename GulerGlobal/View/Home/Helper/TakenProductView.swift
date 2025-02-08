//
//  TakenProductView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11.08.2024.
//

import SwiftUI

struct TakenProductView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: MainViewModel
    @State private var hiddingAnimation: Bool = false
    
    var body: some View {
        
        LazyVStack(spacing: 5) {
            
            Text("Malzeme Listesi")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(.background, in: .rect(cornerRadius: 20))
            
            ForEach(viewModel.pendingProducts, id: \.self) { tuple in
                ProductListView(
                    title: "Proje Numarası: \(tuple.work.id)",
                    list: tuple.work.productList.filter { !$0.isBought },
                    tuple: tuple,
                    hiddingAnimation: $hiddingAnimation
                )
                .environmentObject(viewModel)
            }
            
        }
        .opacity(viewModel.pendingProducts.isEmpty ? 0 : 1)
    }
}

struct TestTakenProductView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        TakenProductView()
            .environmentObject(viewModel)
    }
}

#Preview {
    TestTakenProductView()
}
