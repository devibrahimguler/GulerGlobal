//
//  DateProperty.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11.02.2024.
//

import SwiftUI

struct DateProperty: View {
    @Environment(\.colorScheme) var scheme
    
    @Binding var date: Date
    
    var title: FormTitle
    @Binding var formTitle: FormTitle
    
    var color: Color = .bSea
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Text(title.rawValue)
                .padding(5)
                .background(.white)
                .foregroundStyle(.gray)
                .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                .overlay {
                    RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                        .stroke(style: .init(lineWidth: 3))
                        .fill(formTitle == title ? .blue : .gray )
                }
                .zIndex(1)
                .padding(.horizontal, 5)
            
            Button {
                withAnimation(.snappy) {
                    formTitle = title
                    hideKeyboard()
                }
            } label: {
                Text("\(date.getStringDate(.long))")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .background(.hWhite)
                    .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight, .topRight]))
                    .overlay {
                        RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight, .topRight])
                            .stroke(style: .init(lineWidth: 3))
                            .fill(formTitle == title ? .blue : .gray )
                    }
                    .padding(.top, 23)
                    .padding(5)
            
            }
            .zIndex(0)

            
        }
        .font(.system(size: 15, weight: .black, design: .monospaced))
        .foregroundStyle(color)
    }
}

struct TestDateProperty: View {
    @State private var formTitle: FormTitle = .startDate
    @State private var date: Date = .now
    
    var body: some View {
        DateProperty(date: $date, title: .startDate, formTitle: $formTitle)
    }
}

#Preview {
    TestDateProperty()
        .preferredColorScheme(.dark)
}
