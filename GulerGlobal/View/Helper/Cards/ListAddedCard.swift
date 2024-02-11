//
//  ListAddedCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 9.02.2024.
//

import SwiftUI

struct ListAddedCard: View {
    @Binding var text: String
    @Binding var date: Date
    
    @Binding var list: [String]
    @Binding var isPickerShower: Bool
    @Binding var dateSection: DateSection
    
    var section: DateSection
    var textDesc: String
    var dateDesc: String
    
    var body: some View {
        VStack(spacing: 5) {
            VStack(spacing: 5) {
                HStack {
                    TextProperty(text: $text, desc: textDesc, keyboardType: .numberPad)
                }
               
                HStack {
                   
                    
                    DateProperty(date: $date, dateSection: $dateSection, isPickerShower: $isPickerShower, section: section, desc: dateDesc)
                }
                
                
            }
            .padding(.vertical, 5)
            
            Button {
                withAnimation(.snappy) {
                    list.append("\(date.formatted(date: .long, time: .omitted)) - \(text)")
                    text = ""
                    
                }
            } label: {
                Image(systemName: "plus.diamond.fill")
                    .font(.title)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(style: .init(lineWidth: 1))
                            .fill(.black.opacity(0.5))
                            .shadow(color: .black, radius: 10, y: 5)
                        
                    }
                
                    .padding(10)
                    .background(.BG)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
    
            }
            .disabled(text == "" )
            
            VStack(spacing: 5) {
                ForEach(list, id: \.self) { value in
                    let dicValue = value.components(separatedBy: "-")
                    let day = dicValue[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let price = dicValue[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    CashCard(day: day, price: price) {
                        if let index = list.firstIndex(of: value) {
                            list.remove(at: index)
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
