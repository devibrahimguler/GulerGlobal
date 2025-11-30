//
//  Property.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 16.02.2024.
//

import SwiftUI

struct ChartCard: View {
    @Environment(\.colorScheme) var colorScheme
    
    var title: String
    var description: String
    
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
            
            
            Label {
                Text(description)
            } icon: {
                Image(systemName: "turkishlirasign")
            }
                .frame(maxWidth: .infinity)
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(.vertical, 5)
                .background(color.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(lineWidth: 3)
                        .fill(Color.accentColor.gradient)
                }
                .foregroundStyle(.white)
            
        }
        .foregroundStyle(.black)
        .padding(.vertical, 5)
    }
}

#Preview {
    ChartCard(title: "title", description: "27.500", color: .bRenk)
}
