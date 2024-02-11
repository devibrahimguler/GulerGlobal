//
//  WorkProperty.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.02.2024.
//

import SwiftUI

struct WorkProperty: View {
    var text: String
    var desc: String
    var alignment: HorizontalAlignment
    
    var background: Color = .white
    var foregroundStyle: Color = .black
    
    var body: some View {
        VStack(alignment: alignment, spacing: 3) {
            Text(text)
                .font(.subheadline.bold())
                .foregroundStyle(.gray)
            
            Text(desc)
                .padding(7)
                .font(.headline.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(.leading)
                .shadow(radius: 1)
        }
        .foregroundStyle(foregroundStyle)
    }
}

#Preview {
    ContentView()
}

