//
//  HomeScreenButton.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 23.10.2024.
//

import SwiftUI

struct NavigationButton<Content: View>: View {
    @Environment(\..colorScheme) private var colorScheme
    let content: Content
    let buttonType: ButtonType

    var body: some View {
        NavigationLink(destination: content) {
            VStack(spacing: 8) {
                Image(systemName: buttonType.symbolImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)

                Text(buttonType.rawValue)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 75, height: 75)
            .padding(10)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
        }
    }
}

struct Test_NavigationButton: View {
    var body: some View {
        NavigationButton(content: Text("deneme"), buttonType: .debt)
    }
}

#Preview {
    Test_NavigationButton()
}
