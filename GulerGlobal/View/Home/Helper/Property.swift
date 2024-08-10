//
//  Property.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 16.02.2024.
//

import SwiftUI

struct Property: View {
    @Environment(\.colorScheme) var colorScheme
    
    var title: String
    var desc: String
    
    var color: Color = .hWhite
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Text(title.uppercased())
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .padding(.horizontal, 10)
                .background(.white)
                .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                .overlay {
                    RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                        .stroke(style: .init(lineWidth: 1))
                        .fill(.lGray)
                }
                .foregroundStyle(.bSea)
                .zIndex(1)
            
            
            Text(desc)
                .font(.system(size: 15, weight: .black, design: .rounded))
                .frame(maxWidth: .infinity)
                .background(color)
                .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight, .topRight]))
                .overlay {
                    RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight, .topRight])
                        .stroke(style: .init(lineWidth: 1))
                        .fill(.lGray)
                }
                .foregroundStyle(color == .red || color == .green ? .white : .black)
                .padding(.top,15)
                .zIndex(0)
                .shadow(color: colorScheme == .dark ? .white : .black ,radius: 5)
            
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    Property(title: "title", desc: "27.500")
        .preferredColorScheme(.dark)
}
