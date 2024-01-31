//
//  WorkProperty.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 30.01.2024.
//

import SwiftUI

struct WorkProperty: View {
    var text: String
    var desc: String
    var alignment: HorizontalAlignment
    
    var background: Color = .white
    var foregroundStyle: Color = .black
    
    var body: some View {
        VStack(alignment: alignment) {
            Text(text)
                .foregroundStyle(.gray)
                .font(.caption)
            
            Text(desc)
                .padding(2)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .foregroundStyle(foregroundStyle)
    }
}

#Preview {
    ContentView()
}
