//
//  DateProperty.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11.02.2024.
//

import SwiftUI

struct DateProperty: View {
    @Environment(\.colorScheme) var scheme
    
    @Binding var timePicker: Date
    @Binding var date: Date
    @Binding var isPickerShower: Bool
    @Binding var formTitle: FormTitle
    
    var title: FormTitle
    var color: Color = .bSea
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Text(title.rawValue)
                .padding(5)
                .background(.white)
                .foregroundStyle(.gray)
                .clipShape(RoundedCorner(radius: 5, corners: [.topLeft, .topRight]))
                .overlay {
                    RoundedCorner(radius: 5, corners: [.topLeft, .topRight])
                        .stroke(style: .init(lineWidth: 3))
                        .fill(formTitle == title ? .blue : .gray )
                }
                .zIndex(1)
                .padding(.horizontal, 5)
            
            Button {
                withAnimation(.snappy) {
                    formTitle = title
                    date = timePicker
                    isPickerShower = true
                    hideKeyboard()
                }
            } label: {
                Text("\(date.getStringDate())")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .background(.hWhite)
                    .clipShape(RoundedCorner(radius: 5, corners: [.bottomLeft, .bottomRight, .topRight]))
                    .overlay {
                        RoundedCorner(radius: 5, corners: [.bottomLeft, .bottomRight, .topRight])
                            .stroke(style: .init(lineWidth: 3))
                            .fill(formTitle == title ? .blue : .gray )
                    }
                    .padding(.top, 17)
                    .padding(5)
            
            }
            .zIndex(0)

            
        }
        .font(.system(size: 10, weight: .black, design: .monospaced))
        .foregroundStyle(color)
    }
}

struct TestDateProperty: View {
    @State private var date: Date = .now
    @State private var timePicker: Date = .now
    @State private var isPickerShower: Bool = false
    @State private var formTitle: FormTitle = .startDate
    
    var body: some View {
        DateProperty(timePicker: $timePicker, date: $date, isPickerShower: $isPickerShower, formTitle: $formTitle, title: .startDate)
    }
}

#Preview {
    TestDateProperty()
        .preferredColorScheme(.dark)
}
