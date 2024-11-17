//
//  ProductCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 10.08.2024.
//

import SwiftUI

struct ProductCard: View {
    @Environment(\.colorScheme) var colorScheme
    
    var pro: Product
    var color: Color = .hWhite
    var action: ((Bool) -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            let totalPrice = Double(pro.quantity) * Double(pro.price)
            
            HStack(alignment: .center, spacing: 0) {
                if !pro.isBought {
                    Button {
                        if let action = action {
                            action(true)
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.headline.bold())
                            .foregroundStyle(Color.accentColor)
                    }
                    .padding(.horizontal, 8)
                    .clipShape(RoundedCorner(radius: 10, corners: [.bottomRight, .topLeft]))
                    
                }
                
                Spacer()
                
                Text("\(pro.suggestion)")
                    .font(.system(size: 15, weight: .black, design: .default))
                    .foregroundStyle(colorScheme == .light ? .primary : Color.white)
                    .padding(5)
                   
                
                Spacer()
                
                Button {
                    if let action = action {
                        action(false)
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.headline.bold())
                        .foregroundStyle(.red)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .topRight]))
                
                

            }
            .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
            .overlay {
                RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                    .stroke(style: .init(lineWidth: 3))
                    .fill(.gray)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(pro.name)")
                        .font(.system(size: 18, weight: .black, design: .default))
                        .foregroundStyle(pro.isBought ? .gray : Color.accentColor)
                        .lineLimit(1)
                    
                    Text("\(pro.purchased.getStringDate(.short))")
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("ADET: \(pro.quantity)")
                        .foregroundStyle(.gray)
                    
                    Text("FİYAT: \(pro.price.customDouble()) ₺")
                        .foregroundStyle(.gray)
                    
                    Text("TOPLAM FİYAT: \(totalPrice.customDouble()) ₺")
                        .foregroundStyle(.gray)
                }
            }
            .padding(10)
            .foregroundStyle(pro.isBought ? .white : .black)
            .background(pro.isBought ? Color.accentColor : color)
            .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight]))
            .overlay {
                RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight])
                    .stroke(style: .init(lineWidth: 3))
                    .fill(.gray)
            }
            
        }
        .frame(maxWidth: .infinity)
        .font(.system(size: 10, weight: .black, design: .default))
        .padding(5)
  
    }
}

struct TestProductCard: View {
    var pro: Product = .init(name: "Name", quantity: 2, price: 200, suggestion: "Yıldız", purchased: .now, isBought: false)
    var body: some View {
        ProductCard(pro: pro)
    }
}

#Preview {
    TestProductCard()
}
