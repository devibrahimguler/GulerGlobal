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
        VStack(alignment: .leading, spacing: 0) {
            
            Text(title.uppercased())
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .padding(.horizontal, 10)
                .padding(.vertical, 1)
                .background(.white)
                .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                .overlay {
                    RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                        .stroke(style: .init(lineWidth: 2))
                        .fill(.gray)
                }
            
            
            Text(desc)
                .frame(maxWidth: .infinity)
                .font(.system(size: 15, weight: .black, design: .rounded))
                .padding(.horizontal, 10)
                .padding(.vertical, 1)
                .background(color)
                .clipShape(RoundedCorner(radius: 10, corners: [.topRight, .bottomRight, .bottomLeft]))
                .overlay {
                    RoundedCorner(radius: 10, corners: [.topRight, .bottomRight, .bottomLeft])
                        .stroke(style: .init(lineWidth: 2))
                        .fill(.gray)
                }
                .foregroundStyle(color == .red || color == .green ? .white : .black)
            
        }
        .foregroundStyle(.black)
        .padding(.vertical, 5)
    }
}

#Preview {
    Property(title: "title", desc: "27.500")
        .preferredColorScheme(.dark)
}
