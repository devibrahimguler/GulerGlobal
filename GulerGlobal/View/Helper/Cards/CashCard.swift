//
//  CashCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 9.02.2024.
//

import SwiftUI

struct CashCard: View {
    @Environment(\.colorScheme) var scheme
    
    var day: String
    var price: String
    var action: () -> ()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text("\(day)")
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5).stroke(style: .init(lineWidth: 1))
                        .fill(.black.opacity(0.5))
                        .shadow(color: .black, radius: 10, y: 5)
                }
                .padding(.leading, 10)
                .zIndex(1)
            
            HStack(spacing: 30) {
                HStack {
                    Spacer()
                    
                    Text("\(price) ₺")
                        

                }
                .padding(6)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(style: .init(lineWidth: 1))
                        .fill(.black.opacity(0.5))
                        .shadow(color: .black, radius: 10, y: 5)
                    
                }
                
                Button {
                    withAnimation(.snappy) {
                        action()
                    }
                } label: {
                    Image(systemName: "minus.diamond")
                        .font(.title2)
                        .foregroundStyle(.red)
                        .background(.white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(style: .init(lineWidth: 1))
                                .fill(.red.opacity(0.5))
                                .shadow(color: .black, radius: 10, y: 5)
                            
                        }
                }

            }
            .padding(20)
            .background(.BG)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(.top, 15)
            
        }
        .font(.headline.bold().monospaced())
        .foregroundStyle(scheme == .light ? .white : .black)
    }
}

#Preview {
    CashCard(day: "27 april 2024", price: "3000") {
        
    }
    .preferredColorScheme(.dark)
}
