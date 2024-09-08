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
    var isHaveButton: Bool = false
    var color: Color = .hWhite
    var action: ((_ isDelete: Bool) -> ())?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Text("\(date.getStringDate())")
                .padding(5)
                .background(.white)
                .foregroundStyle(.gray)
                .clipShape( RoundedCorner(radius: 5, corners: [.topLeft, .topRight]))
                .overlay {
                    RoundedCorner(radius: 5, corners: [.topLeft, .topRight])
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
                    .clipShape(RoundedCorner(radius: 5, corners: [.bottomLeft, .bottomRight, .topRight]))
                    .multilineTextAlignment(.center)
                    .overlay {
                        RoundedCorner(radius: 5, corners: [.bottomLeft, .bottomRight, .topRight])
                            .stroke(style: .init(lineWidth: 3))
                            .fill(.gray)
                    }
                    .zIndex(0)
                    .padding(.top, 17)
                    .padding(5)
                
                if isHaveButton {
                    if isExp {
                        Button {
                            withAnimation(.snappy) {
                                if let action = action {
                                    action(false)
                                }
                            }
                        } label: {
                            Image(systemName: "plus.app")
                                .font(.title)
                                .foregroundStyle(.green)
                                .padding(5)
                                .padding(.top, 17)
                            
                            
                        }
                    }
                    
                    Button {
                        withAnimation(.snappy) {
                            if let action = action {
                                action(true)
                            }
                        }
                    } label: {
                        Image(systemName: "minus.square")
                            .font(.title)
                            .foregroundStyle(.red)
                            .padding(5)
                            .padding(.top, 17)
                    }
                }
                
            }
        }
        .font(.system(size: 10, weight: .black, design: .monospaced))
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
