//
//  CustomDatePicker.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 26.10.2024.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var timePicker: Date
    var title: FormTitle
    @Binding var formTitle: FormTitle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
            
            DatePicker("", selection: $timePicker, displayedComponents: .date)
                .padding(.horizontal, 23)
                .colorScheme(.light)
                .environment(\.locale, Locale.init(identifier: "tr"))
                .datePickerStyle(.wheel)
                .background(.hWhite)
                .clipShape(RoundedCorner(radius: 10, corners: [.topRight, .bottomRight, .bottomLeft]))
                .overlay {
                    RoundedCorner(radius: 10, corners: [.topRight, .bottomRight, .bottomLeft])
                        .stroke(style: .init(lineWidth: 3))
                        .fill(formTitle == title ? .blue : .gray )
                }
        }
        .font(.system(size: 15, weight: .black, design: .monospaced))
        .padding(5)
    }
}

struct CustomDatePickerTest: View {
    @State private var formTitle: FormTitle = .startDate
    @State private var timePicker: Date = .init()

    var body: some View {
        CustomDatePicker(timePicker: $timePicker, title: .startDate, formTitle: $formTitle)
    }
}

#Preview {
    CustomDatePickerTest()
}
