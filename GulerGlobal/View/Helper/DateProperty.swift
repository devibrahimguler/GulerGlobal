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
    @Binding var dateSection: DateSection
    @Binding var isPickerShower: Bool
    var section: DateSection
    var desc: String
    var color: Color = .black
    

    
    init(timePicker: Binding<Date>, date: Binding<Date>, dateSection: Binding<DateSection>, isPickerShower: Binding<Bool>, section: DateSection, desc: String, color: Color = .black) {
        self._timePicker = timePicker
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
            
            Text("\(date.getStringDate())")
                .frame(maxWidth: .infinity)
                .propartyTextFieldBack()
                .multilineTextAlignment(.center)
                .shadow(color: scheme == .light ? .black : .white ,radius: 1)
                .frame(maxWidth: .infinity)
                .scaleEffect(dateSection == section ? 0.9 : 1)
                .onTapGesture {
                    withAnimation(.snappy) {
                        dateSection = section
                        date = timePicker
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
    @State private var timePicker: Date = .now
    @State private var dateSection: DateSection = .none
    @State private var isPickerShower: Bool = false
    
    var body: some View {
        DateProperty(timePicker: $timePicker, date: $date, dateSection: $dateSection, isPickerShower: $isPickerShower, section: .none, desc: "Time")
    }
}

#Preview {
    TestDateProperty()
}

extension Date {
    func getStringDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr")
        formatter.dateStyle = .long
        
        return formatter.string(from: self)
    }
}
