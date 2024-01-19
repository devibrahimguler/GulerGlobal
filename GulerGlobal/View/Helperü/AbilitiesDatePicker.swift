//
//  AbilitiesDatePicker.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct AbilitiesDatePicker: View {
    @Binding var date: Date
    @Binding var isPickerShower: Bool
    @Binding var pickerSelector: PickerSelector
    
    var desc: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(desc)
                .font(.headline)
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5).stroke(style: .init(lineWidth: 1))
                        .fill(.black.opacity(0.5))
                        .shadow(color: .black, radius: 10, y: 5)
                }
                .padding(.leading, 10)
                .zIndex(1)
            
            Text("\(date.formatted(date: .long, time: .omitted))")
                .frame(maxWidth: .infinity)
                .padding(6)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .fontDesign(.monospaced)
                .foregroundStyle(.black)
                .overlay {
                    RoundedRectangle(cornerRadius: 5).stroke(style: .init(lineWidth: 1))
                        .fill(.black.opacity(0.5))
                        .shadow(color: .black, radius: 10, y: 5)
                }
                .padding(20)
                .background(.BG)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(.top, 15)
                .onTapGesture {
                    withAnimation(.snappy) {
                        isPickerShower = true
                        pickerSelector = desc == "BAŞLAMA TARİHİ" ? .stPicker : .fnPicker
                    }
                }
            
        }
        .fontDesign(.monospaced)
        .fontWeight(.bold)
    }
}

struct TestAbilitiesDatePicker : View {
    @State var date: Date = .now
    @State var isPickerShower: Bool = false
    @State var pickerSelector: PickerSelector = .none
    
    var body: some View {
        AbilitiesDatePicker(date: $date, isPickerShower: $isPickerShower, pickerSelector: $pickerSelector, desc: "BAŞLAMA TARİHİ")
    }
}

#Preview {
    TestAbilitiesDatePicker()
}

enum PickerSelector {
    case none, stPicker, fnPicker
}
