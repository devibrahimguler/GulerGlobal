//
//  ProductCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 10.08.2024.
//

import SwiftUI

struct ProductCard: View {
    @Environment(\.colorScheme) var colorScheme
    var isDetail: Bool
    var pro: Product
    var color: Color = .hWhite
    var complation: () -> ()
    
    var body: some View {
        HStack(spacing: 5) {
            HStack {
                let totalPrice = Double(pro.quantity) * Double(pro.price)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("İSMİ: ")
                            .foregroundStyle(.blue)
                        
                        Text("\(pro.name)")
                    }
                    
                    HStack {
                        Text("YER: ")
                            .foregroundStyle(.blue)
                        
                        Text("\(pro.suggestion)")
                    }
                    
                    HStack {
                        
                        Text("TARİH: ")
                            .foregroundStyle(.blue)
                        
                        Text("\(pro.purchased.getStringDate())")
                    }
                    
                    
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("ADET: ")
                            .foregroundStyle(.blue)
                        
                        Text("\(pro.quantity)")
                    }
                    
                    HStack {
                        Text("FİYAT: ")
                            .foregroundStyle(.blue)
                        
                        Text("\(pro.price.customDouble()) ₺")
                    }
                    
                    HStack {
                        Text("TOPLAM: ")
                            .foregroundStyle(.blue)
                        
                        Text("\(totalPrice.customDouble()) ₺")
                    }
                }
            }
            .font(.system(size: 12, weight: .black, design: .default))
            .foregroundStyle(pro.isBought ? .white : .black)
            .padding(10)
            .background(pro.isBought ? .green : color)
            .clipShape(RoundedCorner(radius: 10))
            .overlay {
                RoundedCorner(radius: 10)
                    .stroke(style: .init(lineWidth: 1))
                    .fill(.lGray)
            }
            .shadow(color: colorScheme == .dark ? .white : .black ,radius: 2)
    
            if isDetail && !pro.isBought {
                Button {
                    withAnimation(.snappy) {
                        complation()
                    }
                } label: {
                    Image(systemName: "plus.app")
                        .font(.title)
                        .foregroundStyle(.hWhite)
                        .shadow(color: colorScheme == .dark ? .white : .black ,radius: 2)

                }
            } else if !isDetail {
                Button {
                    withAnimation(.snappy) {
                       complation()
                    }
                } label: {
                    Image(systemName: "minus.square")
                        .font(.title)
                        .foregroundStyle(.red)
                        .shadow(color: colorScheme == .dark ? .white : .black ,radius: 2)
                }
            }
        }
        .padding([.horizontal], 5)
        .padding([.vertical], 5)
    }
}

struct TestProductCard: View {
    var pro: Product = .init(name: "Name", quantity: 2, price: 200, suggestion: "Yıldız", purchased: .now, isBought: false)
    var body: some View {
        ProductCard(isDetail: false, pro: pro) {
            
        }
    }
}

#Preview {
    TestProductCard()
}
