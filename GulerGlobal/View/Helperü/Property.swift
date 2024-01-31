//
//  Property.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 30.01.2024.
//

import SwiftUI

struct Property: View {
    @Binding var text: String
    
    var desc: String
    var keyStyle: KeyboardStyle = .text
    
    var isWorkRem: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(desc)
                .font(.headline)
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
            
            TextField(text != "" ? text: "",text: $text)
                .padding(6)
                .keyboardType(keyStyle == .text ? .default : keyStyle == .phone ? .phonePad : .numberPad)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: .init(lineWidth: 1))
                    .fill(.black.opacity(0.5))
                    .shadow(color: .black, radius: 10, y: 5)
            }
            
            .padding(20)
            .background(.BG)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            .padding(.top, 15)
            .foregroundStyle(.black)
            .multilineTextAlignment(keyStyle == .time ? .center : .leading)
            .disabled(keyStyle == .time ? true : false)
            
            
        }
        
        .disabled(isWorkRem)
    }
}

#Preview {
    ContentView()
}
