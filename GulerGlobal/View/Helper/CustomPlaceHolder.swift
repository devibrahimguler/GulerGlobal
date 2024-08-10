//
//  CustomPlaceHolder.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 25.07.2024.
//

import SwiftUI

struct CustomPlaceHolder: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimation = false
    
    var body: some View {
        ZStack(alignment: .center) {
            
            Text("Guler Global")
                .font(.system(size: 40, weight: .black, design: .rounded))
                .offset(y: -150)
                .zIndex(1)
            
            ForEach(0...5, id: \.self) { i in
                Circle() // Ball
                    .fill(.star)
                    .frame (width: 10, height: 10)
                    .offset(y: -30 - Double(i) * 15)
                    .rotationEffect(.degrees(isAnimation ? 360 : 0))
                    .animation(.easeInOut(duration: Double(i) + 0.7).repeatForever(autoreverses: false), value: isAnimation)
                    .shadow(color:colorScheme == .light ? .black : .white,radius: 3)
                    .blur(radius: 1)
            }
            .zIndex(3)
           
            Image("icon")
                .resizable()
                .frame(width: 40, height: 40)
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                .shadow(color:colorScheme == .light ? .black : .white,radius: 20)
                .zIndex(2)
        }
        .onAppear {
            self.isAnimation.toggle()
        }
    }
}

#Preview {
    CustomPlaceHolder()
        .preferredColorScheme(.dark)
}
