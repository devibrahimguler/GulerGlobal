//
//  HomeScreenButton.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 23.10.2024.
//

import SwiftUI

struct NavigationButton<Content: View>: View {
    let content: Content
    let buttonType: ButtonType
    let description: String
    
    var body: some View {
        NavigationLink(destination: content) {
            VStack {
                HStack {
                    Image(systemName: buttonType.symbolImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(15)
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
                        .foregroundStyle(.accent)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(buttonType.rawValue)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(description)
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                    }
                    .foregroundStyle(.gray)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                        .padding()
                        .foregroundStyle(.gray)
                    
                    
                }
                .frame(height: 70)
                .padding(10)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30))
            }
        }
    }
}

struct Test_NavigationButton: View {
    var body: some View {
        NavigationButton(
            content: Text("deneme"),
            buttonType: .debt,
            description: "deneme"
        )
    }
}

#Preview {
    Test_NavigationButton()
}
