//
//  SwipeButton.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 22.09.2024.
//

import SwiftUI

struct SwipeButton: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    var approveText: String
    var work: Work
    var buttonStyle: ButtonStyle
    
    var body: some View {
        Button {
            withAnimation(.snappy) {
                viewModel.updateWork(.init(
                    id: work.id,
                    companyId: work.companyId,
                    name: work.name,
                    desc: work.desc,
                    price: work.price,
                    approve: approveText,
                    accept: work.accept,
                    products: work.products)
                )
                
            }
        } label: {
            Image(systemName: buttonStyle.rawValue)
                .font(.title.bold())
                .foregroundStyle(.white)
                .contentShape(Rectangle())
        }
        .tint(buttonStyle == .accept ? .green :.red)
    }
}

#Preview {
    ContentView()
}
