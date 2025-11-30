//
//  CustomPlaceHolder.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 25.07.2024.
//

import SwiftUI

struct CustomPlaceHolder: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var isAnimating = false
    
    var distance: CGFloat = 2.5
    
    var body: some View {
        ZStack(alignment: .center) {
            // Main Icon
            Image("icon")
                .resizable()
                .scaledToFit()
                .frame(width: 150 / distance, height: 150 / distance)
                .clipShape(Circle())
                .shadow(radius: 1)
                .zIndex(1)
            
            // Rotating Circles
            ForEach(0...3, id: \.self) { index in
                Circle()
                    .fill(Color.isYellow)
                    .frame(width: 40 / distance, height: 40 / distance)
                    .offset(y: -(160 / distance) - CGFloat(index) * (60 / distance))
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(
                        .linear(duration: Double(index) + 1)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
                    .shadow(radius: 1)
                    .blur(radius: distance == 1 ? 2 : 1)
            }
            .zIndex(0)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    CustomPlaceHolder()
        .preferredColorScheme(.dark)
}
