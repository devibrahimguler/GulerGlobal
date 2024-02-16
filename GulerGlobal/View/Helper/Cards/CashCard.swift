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
            Text("\(date.formatted(date: .long, time: .omitted))")
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5).stroke(style: .init(lineWidth: 1))
                        .fill(.black.opacity(0.5))
                        .shadow(color: .black, radius: 10, y: 5)
                }
                .padding(.leading, 25)
                .zIndex(1)
            
            HStack(spacing: 10) {
                
                Text("\(price.removeZerosFromEnd()) ₺")
                    .frame(maxWidth: .infinity)
                    .padding(6)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: .init(lineWidth: 1))
                            .fill(.black.opacity(0.5))
              
                    }
                    .padding(20)
                    .background(.BG)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: .black, radius: 1)
                    .padding(.top, 15)
                
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
                            .background(.BG)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black, radius: 1)
                            .padding(.top, 20)
                        
                        
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
                        .background(.BG)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black, radius: 1)
                        .padding(.top, 20)
                }
            }
            
            
        }
        .font(.headline.bold().monospaced())
        .foregroundStyle(.black)
    }
}

#Preview {
    CashCard(date: .now, price: 200, isExp: true) { isDelete in
        
    }
    .preferredColorScheme(.light)
}

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
