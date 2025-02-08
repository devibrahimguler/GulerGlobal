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
            .foregroundStyle(.bRenk.gradient)
            .frame(width: 75, height: 75)
            .padding(10)
            .background(Color.accentColor.gradient)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
    }
}

struct Test_NavigationButton: View {
    var body: some View {
        NavigationButton(content: Text("deneme"), buttonType: .cancel)
    }
}

#Preview {
    Test_NavigationButton()
}
