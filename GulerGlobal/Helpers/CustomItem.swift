//
//  CustomItem.swift
//  GulerGlobal
//
//  Created by ibrahim on 15.12.2025.
//

import SwiftUI

struct CustomItem: ToolbarContent {
    let title: String
    let icon: String
    let action: () -> Void
    let isClicked: Bool
    
    init(title: String, icon: String, isClicked: Bool, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isClicked = isClicked
        self.action = action
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(role: .confirm) {
                action()
            } label: {
                Label(title, systemImage: icon)
            }
            .foregroundStyle(.green)
            .font(.headline)
            .fontWeight(.semibold)
            .disabled(isClicked)
        }
    }
}
