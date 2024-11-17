//
//  HomeScreenButton.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 23.10.2024.
//

import SwiftUI

struct HomeScreenButton<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    var content: Content
    var buttonType: ButtonType
    
    var body: some View {
        
        NavigationLink {
            content
        } label: {
            VStack {
                
                Image("\(buttonType)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text("\(buttonType.rawValue)")
                    .font(.system(size: 12, weight: .black))
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(10)
        .background(.hWhite)
        .clipShape(RoundedCorner(radius: 10))
        .overlay {
            RoundedCorner(radius: 10)
                .stroke(style: .init(lineWidth: 3))
                .fill(.gray)
        }
        .shadow(color: colorScheme == .dark ? .white : .black ,radius: 1)
    }
}

struct TestHomeScreenButton: View {
    var body: some View {
        HomeScreenButton(content: Text("deneme"), buttonType: .cancel)
    }
}

#Preview {
    TestHomeScreenButton()
}
