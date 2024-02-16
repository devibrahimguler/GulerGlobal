//
//  TextProperty.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11.02.2024.
//

import SwiftUI

struct TextProperty: View {
    @Environment(\.colorScheme) var scheme
    
    @Binding var text: String
    
    var desc: String
    var keyboardType: UIKeyboardType = .default
    var color: Color = .black
    
    init(text: Binding<String>, desc: String, keyboardType: UIKeyboardType = .default, color: Color = .black) {
        self._text = text
        self.desc = desc
        self.keyboardType = keyboardType
        self.color = color
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Text(desc)
                .frame(maxWidth: .infinity)
                .propartyTextdBack()
                .padding(.horizontal)
            
            TextField("",text: $text)
                .padding(.leading, 10)
                .keyboardType(keyboardType)
                .propartyTextFieldBack()
                .multilineTextAlignment(.leading)
                .shadow(color: scheme == .light ? .black : .white ,radius: 2)
            
        }
        .font(.headline.bold().monospaced())
        .foregroundStyle(color)
    }
}

struct TestTextProperty: View {
    @State private var text: String = "asdsada"
    var body: some View {
        TextProperty(text: $text, desc: "Text")
    }
}

#Preview {
    TestTextProperty()
}

extension View {
    func propartyTextFieldBack() -> some View {
        self
            .padding(6)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: .init(lineWidth: 1))
                    .fill(.black)
            }
            .padding(15)
            .background(.BG)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.top, 20)
    }
    
    func propartyTextdBack() -> some View {
        self
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10).stroke(style: .init(lineWidth: 1))
                    .fill(.gray)
            }
            .zIndex(1)
    }
}
