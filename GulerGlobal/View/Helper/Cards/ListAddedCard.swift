//
//  ListAddedCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 9.02.2024.
//

import SwiftUI

struct ListAddedCard: View {
    var now: Date
    var isExpiry: Bool
    
    @Binding var text: String
    @Binding var day: String
    @Binding var list: [String]
    @Binding var isPickerShower: Bool
    @Binding var pickerSelector: PickerSelector
    
    var body: some View {
        VStack(spacing: 5) {
            VStack(spacing: 5) {
                HStack {
                    
                    Property(text: $text, desc: isExpiry ? "ALINACAK PARA" : "ALINAN PARA", keyStyle: .numaric)
                }
               
                HStack {
                   
                    
                    Property(text: $day, desc: isExpiry ? "PARA ALINACAK TARİH" : "PARA ALMA TARİHİ", keyStyle: .time)
                        .scaleEffect(pickerSelector == (isExpiry ? .expiry : .getCash) ? CGSize(width: 0.9, height: 0.9) : CGSize(width: 1.0, height: 1.0))
                        .onTapGesture {
                            withAnimation(.snappy) {
                                pickerSelector = isExpiry ? .expiry : .getCash
                                isPickerShower = true
                                hideKeyboard()
                            }
                        }
                }
                
                
            }
            .padding(.vertical, 5)
            
            Button {
                withAnimation(.snappy) {
                    list.append("\(day) - \(text)")
                    day = now.formatted(date: .long, time: .omitted)
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
            .disabled(day == "" || text == "" )
            
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
