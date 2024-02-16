//
//  ListAddedCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 9.02.2024.
//

import SwiftUI

struct ListAddedCard: View {
    @EnvironmentObject var companyViewModel: CompanyViewModel
    
    @Binding var timePicker: Date
    @Binding var workRem: String
    @Binding var text: String
    @Binding var date: Date
    
    @Binding var list: Set<Statement>
    @Binding var recList: Set<Statement>
    @Binding var isPickerShower: Bool
    @Binding var dateSection: DateSection
    
    var section: DateSection
    var textDesc: String
    var dateDesc: String
    var isExp: Bool = false
    
    var body: some View {
        VStack(spacing: 5) {
            VStack(spacing: 5) {
                HStack {
                    TextProperty(text: $text, desc: textDesc, keyboardType: .numberPad)
                }
                
                HStack(spacing: 20) {
                    Button {
                        withAnimation(.snappy) {
                            let newStatement = Statement(context: companyViewModel.container.viewContext)
                            newStatement.date = date
                            newStatement.price = Double(text) ?? 0
                            list.insert(newStatement)
                            text = ""
                        }
                    } label: {
                        Image(systemName: "plus.app")
                            .font(.title)
                            .padding(5)
                            .background(.BG)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .shadow(color: .black, radius: 1)
                            .padding(.top, 25)
                        
                    }
                    .disabled(text == "" )
                    
                    DateProperty(timePicker: $timePicker, date: $date, dateSection: $dateSection, isPickerShower: $isPickerShower, section: section, desc: dateDesc)
                    
                    
                }
                
                
            }
            .padding(.vertical, 5)
            
           
            
            VStack(spacing: 5) {
                ForEach(list.sorted{$0.date ?? .now < $1.date ?? .now}, id: \.self) { statement in
                    CashCard(date: statement.date ?? .now, price: statement.price, isExp: isExp) { isDelete in
                        if let index = list.firstIndex(of: statement) {
                            list.remove(at: index)
                            
                            if !isDelete {
                                let newStatement = Statement(context: companyViewModel.container.viewContext)
                                newStatement.date = statement.date
                                newStatement.price = statement.price
                                workRem = "\((Double(workRem) ?? 0) - statement.price)"
                                recList.insert(newStatement)
                            } else {
                                if !isExp {
                                    workRem = "\((Double(workRem) ?? 0) + statement.price)"
                                }
                            }
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
