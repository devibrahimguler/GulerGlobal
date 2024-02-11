//
//  Property.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.02.2024.
//

import SwiftUI

struct Property: View {
    @Environment(\.colorScheme) var scheme
    
    @Binding var text: String
    
    var desc: String
    
    var isWorkRem: Bool = false
    
    var foregroundStyle: Color = .black
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(desc)
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
                .foregroundStyle(foregroundStyle)
                .shadow(color: scheme == .light ? .black : .white ,radius: 5)
            
        }
 
        .font(.headline.bold().monospaced())
        .disabled(isWorkRem)
    }
}

#Preview {
    ContentView()
}

