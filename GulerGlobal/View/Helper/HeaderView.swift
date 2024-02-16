//
//  HeaderView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 7.02.2024.
//

import SwiftUI

struct HeaderView: View {
    var header: String
    var body: some View {
        VStack(spacing: 15 ) {
            Text(header)
                .font(.title2.bold().lowercaseSmallCaps())
                .padding(.horizontal)
        }
        .padding(.vertical, 5)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
