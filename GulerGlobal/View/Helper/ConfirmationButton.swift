//
//  ConfirmationButton.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 16.10.2024.
//

import SwiftUI

struct ConfirmationButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            withAnimation(.snappy) {
                action()
            }
        } label: {
            Text("ONAYLA")
                .padding(5)
        }
        .font(.system(size: 25, weight: .black, design: .monospaced))
        .foregroundStyle(.white)
        .background(.green)
        .clipShape(RoundedCorner(radius: 10))
        .overlay {
            RoundedCorner(radius: 10)
                .stroke(style: .init(lineWidth: 3))
        }
        .padding(.horizontal)
    }
}

struct TestConfirmationButton: View {
    var body: some View {
        ConfirmationButton {
            
        }
    }
}

#Preview {
    TestConfirmationButton()
}
