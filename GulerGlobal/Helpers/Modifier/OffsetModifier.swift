//
//  OffsetModifier.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.02.2024.
//

import SwiftUI

struct OffsetModifier: ViewModifier {
    
    @Binding var offset: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay (
                GeometryReader { proxy -> Color in
                    
                    DispatchQueue.main.async {
                        let minY = proxy.frame(in: .named("SCROLL")).minY
                        self.offset = minY
                    }
                    return Color.clear
                }, alignment: .top
            )
    }
}
