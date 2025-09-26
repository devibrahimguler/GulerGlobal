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
        VStack(alignment: .leading, spacing: 2) {
            
            Text(title)
                .font(.caption2)
                .fontWeight(.semibold)
            
            Label {
                HStack {
                    Text(description)
                    
                    Circle()
                        .fill(color.gradient)
                        .frame(width: 10, height: 10)
                }
            } icon: {
                Image(systemName: "turkishlirasign")
            }
            .font(.caption)
            .fontWeight(.semibold)
            .padding(5)
            .glassEffect(in: RoundedRectangle(cornerRadius: 10))
            
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    ChartCard(title: "title", description: "27.500", color: .isCream)
        .preferredColorScheme(.dark)
}
