//
//  SwipeActionButton.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.02.2024.
//

import SwiftUI

struct SwipeActionButton: View {
    @Binding var dragProgress: CGFloat
    @Binding var isExpanded: Bool
    
    var onAction: () -> ()?
    var color: Color
    var icon: String
    var isClipShape: Bool = false
    
    init(dragProgress: Binding<CGFloat>, isExpanded: Binding<Bool>, onAction: @escaping () -> ()?, color: Color, icon: String, isClipShape: Bool = false) {
        self._dragProgress = dragProgress
        self._isExpanded = isExpanded
        self.onAction = onAction
        self.color = color
        self.icon = icon
        self.isClipShape = isClipShape
    }
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                if color == .red {
                    dragProgress = 1
                } else {
                    dragProgress = .zero
                }

                isExpanded = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                onAction()
            }
        } label: {
            Image(systemName: icon)
                .font(.title.bold())
                .foregroundStyle(.white)
                .contentShape(Rectangle())
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 15)
        .disabled(!isExpanded)
        .background(color)
        .clipShape(RoundedCorner(radius: isClipShape ? 15 : 0, corners: [.topRight, .bottomRight]))
    }
}

#Preview {
    ContentView()
}
