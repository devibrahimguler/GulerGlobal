//
//  CustomHeaderView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 14.02.2024.
//

import SwiftUI

struct CustomHeaderView: View {
    var text: String
    var backAction: () -> ()
    var saveAction: (() -> ())?
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.snappy) {
                    backAction()
                }
            } label: {
                Image(systemName: "arrow.left.square.fill")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.red)
            }
            
            
            Spacer()
            
            if text != "none" {
                Button {
                    withAnimation(.snappy) {
                        (saveAction ?? backAction)()
                    }
                } label: {
                    
                    Text(text)
                       
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .background(.BG)
                .clipShape( RoundedRectangle(cornerRadius: 5, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(.black)
                }
                .font(.title2.bold())
                .foregroundStyle(.green)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
