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
    var isExp: Bool = false
    var action: (_ isDelete: Bool) -> ()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Text("\(date.getStringDate())")
                .padding(5)
                .background(.white)
                .foregroundStyle(.gray)
                .clipShape(RoundedCorner(radius: 5))
                .overlay {
                    RoundedCorner(radius: 5)
                        .stroke(style: .init(lineWidth: 3))
                        .fill(.gray)
                }
                .zIndex(1)
                .padding(.horizontal)
            
            HStack(spacing: 0) {
                Text("\(price.customDouble()) ₺")
                    .frame(maxWidth: .infinity)
                .padding(10)
                .background(.hWhite)
                .clipShape(RoundedCorner(radius: 5))
                .multilineTextAlignment(.center)
                .overlay {
                    RoundedCorner(radius: 5)
                        .stroke(style: .init(lineWidth: 3))
                        .fill(.gray)
                }
                .zIndex(0)
                .padding(.top, 15)
                .padding(5)
                
                if isExp {
                    Button {
                        withAnimation(.snappy) {
                            action(false)
                        }
                    } label: {
                        Image(systemName: "plus.app")
                            .font(.title)
                            .foregroundStyle(.green)
                            .padding(5)
                            .padding(.top, 15)
                        
                        
                    }
                }
                
                Button {
                    withAnimation(.snappy) {
                        action(true)
                    }
                } label: {
                    Image(systemName: "minus.square")
                        .font(.title)
                        .foregroundStyle(.red)
                        .padding(5)
                        .padding(.top, 15)
                }
            }
        }
        .font(.system(size: 15, weight: .black, design: .monospaced))
        .foregroundStyle(.bSea)
    }
}

#Preview {
    CashCard(date: .now, price: 2000000000, isExp: true) { isDelete in
        
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
