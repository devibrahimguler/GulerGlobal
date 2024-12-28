//
//  CashCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 9.02.2024.
//

import SwiftUI

struct CashCard: View {
    var date: Date
    var price: Double
    var color: Color = .hWhite
    var action: (Bool) -> ()
    
    var body: some View {
        ZStack(alignment: .top) {
            
            HStack {
                if color == .yellow {
                    Button {
                        withAnimation(.snappy) {
                            action(true)
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding(5)
                    .background(Color.accentColor)
                }
                
                Text("\(date.getStringDate(.long))")
                    .padding(5)
                
                Button {
                    withAnimation(.snappy) {
                        action(false)
                    }
                } label: {
                    Image(systemName: "minus")
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 10)
                .background(.red)
                   

            }
            .font(.system(size: 13, weight: .black, design: .monospaced))
            .background(.white)
            .foregroundStyle(.black)
            .clipShape( RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
            .overlay {
                RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                    .stroke(style: .init(lineWidth: 3))
                    .fill(.gray)
            }
            .zIndex(1)
            .padding(.horizontal, 5)
            
            HStack(spacing: 0) {
                Text("\(price.customDouble()) ₺")
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background(color)
                    .clipShape( RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .multilineTextAlignment(.center)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(style: .init(lineWidth: 3))
                            .fill(.gray)
                    }
                    .zIndex(0)
                    .padding(.top, 21)
                    .padding(5)
                
            }
        }
        .font(.system(size: 15, weight: .black, design: .monospaced))
        .foregroundStyle(.black)
    }
}

#Preview {
    CashCard(date: .now, price: 2000000000, color: .yellow) { _ in 
        
    }
    .preferredColorScheme(.dark)
}

extension Double {
    func customDouble() -> String {
        let formatter = NumberFormatter()
        
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "."
        
        return String(formatter.string(from: number) ?? "")
    }
}
