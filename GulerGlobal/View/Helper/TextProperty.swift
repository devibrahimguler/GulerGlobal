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
                .propartyTextdBack()
                .padding(.leading, 10)
            
            TextField("",text: $text)
                .keyboardType(keyboardType)
                .propartyTextFieldBack()
                .multilineTextAlignment(.leading)
                .shadow(color: scheme == .light ? .black : .white ,radius: 5)
            
        }
        .font(.headline.bold().monospaced())
        .foregroundStyle(color)
    }
}

struct TestTextProperty: View {
    @State private var text: String = ""
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
    }
    
    func propartyTextdBack() -> some View {
        self
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay {
                RoundedRectangle(cornerRadius: 5).stroke(style: .init(lineWidth: 1))
                    .fill(.black.opacity(0.5))
                    .shadow(color: .black, radius: 10, y: 5)
            }
            .zIndex(1)
    }
}
