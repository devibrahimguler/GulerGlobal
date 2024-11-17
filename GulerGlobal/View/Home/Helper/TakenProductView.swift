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
    
    var body: some View {
        VStack {
            
            Text("ALINACAK LİSTESİ")
                .font(.system(size: 20, weight: .black, design: .default))
                .padding(.top, 5)
            
            ForEach(viewModel.takenProducts, id: \.self) { work in
                VStack {
                    
                    RoundedCorner(radius: 1)
                        .fill(colorScheme == .dark ? .white : .black)
                        .shadow(color: colorScheme == .dark ? .white : .black ,radius: 5, x: 0 , y: 1)
                        .frame(height: 1)
                        .padding(.bottom, 5)
                    
                    VStack {
                        HStack {
                            Text("Proje Numarası:")
                                .foregroundStyle(.blue)
                            
                            Text("\(work.id)")
                                .foregroundStyle(.black)
                        }
                    }
                    .font(.system(size: 12, weight: .black, design: .default))
                    .padding(8)
                    .padding(.horizontal)
                    .background(.hWhite)
                    .clipShape(RoundedCorner(radius: 10))
                    .overlay {
                        RoundedCorner(radius: 10)
                            .stroke(style: .init(lineWidth: 3))
                            .fill(.gray)
                    }
                    .shadow(color: colorScheme == .dark ? .white : .black ,radius: 5, x: 0 , y: 1)
                    
                    LazyVStack(spacing: 0){
                        ForEach(work.products, id: \.self) { product in
                            
                            if !product.isBought {
                                ProductCard(pro: product) { isBought in
                                    viewModel.editProduct(isBought, product: product, work: work)
                                }
                            }
                        }
                    }
                }
                
            }
            .padding([.horizontal])
            
        }
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
