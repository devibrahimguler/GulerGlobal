//
//  SettingNavigation.swift
//  GulerGlobal
//
//  Created by ibrahim on 1.02.2026.
//

import SwiftUI

struct SettingNavigation<Content: View>: View {
    let content: Content
    let settingType: SettingType
    
    var body: some View {
        NavigationLink(destination: content) {
            VStack {
                HStack {
                    Image(systemName: settingType.symbolImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(5)
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 10))
                        .foregroundStyle(.accent)
                    
                    Spacer()
                    
                    Text(settingType.rawValue)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                    
                    Spacer()
                    
                }
                .frame(height: 40)
                .padding(10)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
            }
        }
    }
}

struct Test_SettingNavigation: View {
    var body: some View {
        SettingNavigation(
            content: Text("deneme"),
            settingType: .debt
        )
    }
}

#Preview {
    Test_SettingNavigation()
}
