//
//  Abilities.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct Abilities: View {
    
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
             
            TextField("", text: $text, axis: .vertical)
                .padding(6)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .keyboardType(keyStyle == .text ? .default : keyStyle == .phone ? .phonePad : .numberPad)
                .lineLimit(nil)
                .fontDesign(.monospaced)
                .foregroundStyle(.black)
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
           
        }
        .fontDesign(.monospaced)
        .fontWeight(.bold)
        .disabled(isWorkRem)
    }
}

struct TestAbilities : View {
    @State var text: String = ""
    var body: some View {
        Abilities(text: $text, desc: "İŞ İSMİ")
    }
}

#Preview {
    TestAbilities()
}
