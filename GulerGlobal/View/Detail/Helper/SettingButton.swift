//
//  SettingButton.swift
//  GulerGlobal
//
//  Created by ibrahim on 1.02.2026.
//

import SwiftUI

struct SettingButton: View {
    let settingType: SettingType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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

struct Test_SettingButton: View {
    var body: some View {
        SettingButton(settingType: .debt) {
            
        }
    }
}

#Preview {
    Test_SettingButton()
}
