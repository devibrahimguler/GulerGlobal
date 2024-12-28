//
//  BaseList.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/19/24.
//

import SwiftUI

struct BaseList<Content>: View where Content: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        List {
            content()
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2))
    }
}

struct BaseListTests: View {
    var body: some View {
        BaseList(title: "Teklifler") {
            
        }
    }
}

#Preview {
    BaseListTests()
}
