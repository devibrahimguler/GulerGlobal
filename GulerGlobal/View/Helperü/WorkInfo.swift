//
//  WorkInfo.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 20.01.2024.
//

import SwiftUI

struct WorkInfo: View {
    var text: String
    var desc: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .foregroundStyle(.gray)
            
            Text(desc)
                .padding(2)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .fontDesign(.monospaced)
        .foregroundStyle(.black)
    }
}

struct TestWorkInfo : View {
    var body: some View {
        WorkInfo(text: "İŞ İSMİ", desc: "ÇATI")
    }
}
#Preview {
    TestWorkInfo()
}
