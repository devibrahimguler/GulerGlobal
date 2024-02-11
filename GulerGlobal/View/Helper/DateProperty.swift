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
    @Binding var dateSection: DateSection
    @Binding var isPickerShower: Bool
    var section: DateSection
    var desc: String
    var color: Color = .black
    

    
    init(date: Binding<Date>, dateSection: Binding<DateSection>, isPickerShower: Binding<Bool>, section: DateSection, desc: String, color: Color = .black) {
        self._date = date
        self._dateSection = dateSection
        self._isPickerShower = isPickerShower
        self.section = section
        self.desc = desc
        self.color = color
        
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Text(desc)
                .propartyTextdBack()
                .padding(.leading, 10)
            
            Text("\(date.formatted(date: .long, time: .omitted))")
                .frame(maxWidth: .infinity)
                .propartyTextFieldBack()
                .multilineTextAlignment(.center)
                .shadow(color: scheme == .light ? .black : .white ,radius: 5)
                .frame(maxWidth: .infinity)
                .scaleEffect(dateSection == section ? CGSize(width: 0.9, height: 0.9) : CGSize(width: 1.0, height: 1.0))
                .onTapGesture {
                    withAnimation(.snappy) {
                        dateSection = section
                        isPickerShower = true
                        hideKeyboard()
                    }
                }
        }
        .font(.headline.bold().monospaced())
        .foregroundStyle(color)
    }
}

struct TestDateProperty: View {
    @State private var date: Date = .now
    @State private var dateSection: DateSection = .none
    @State private var isPickerShower: Bool = false
    var body: some View {
        DateProperty(date: $date, dateSection: $dateSection, isPickerShower: $isPickerShower, section: .none, desc: "Time")
    }
}

#Preview {
    TestDateProperty()
}
