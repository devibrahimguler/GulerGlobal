//
//  Note.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI
import SwiftData

struct Note: View {
    @State private var workName: String = ""
    @State private var workDesc: String = ""
    @State private var workPrice: String = ""
    @State private var workRec: String = ""
    @State private var workRem: String = "0"
    @State private var companyName: String = ""
    @State private var companyDesc: String = ""
    @State private var companyAdress: String = ""
    @State private var companyPhone: String = ""
    @State private var workStTime: Date = .now
    @State private var workFnTime: Date = .now
    
    @State private var isPickerShower: Bool = false
    @State private var pickerSelector: PickerSelector = .none
    
    @Binding var companyViewModel: CompanyViewModel
    @Binding var isAddWork: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button {
                    withAnimation(.snappy) {
                        isAddWork = false
                        workName = ""
                        workDesc = ""
                        workPrice = ""
                        workRec = ""
                        workRem = "0"
                        companyName = ""
                        companyDesc = ""
                        companyAdress = ""
                        companyPhone = ""
                        workStTime = .now
                        workFnTime = .now
                    }
                } label: {
                    Image(systemName: "arrow.left.square.fill")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                }

                
                Spacer()
                
                Button {
                    withAnimation(.snappy) {
                        isAddWork = false
                        companyViewModel.createNewGame(
                            workName: workName,
                            workDesc: workDesc,
                            workPrice: workPrice,
                            workRecMoney: workRec,
                            workRemMoney: workRem,
                            workStTime: workStTime,
                            workFnTime: workFnTime,
                            companyName: companyName,
                            companyDesc: companyDesc,
                            companyAdress: companyAdress,
                            companyPhone: companyPhone)
                    }
                } label: {
                    
                    Text("KAYDET")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(.BG)
                        .clipShape( RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(style: StrokeStyle(lineWidth: 1))
                                .foregroundStyle(.black)
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                }
            }
            .padding(.bottom,5)
            Divider()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 10) {
                    
                    Abilities(text: $companyName, desc: "FİRMA İSMİ")
                    
                    Abilities(text: $companyDesc, desc: "FİRMA AÇIKLAMA")
                    
                    Abilities(text: $companyAdress, desc: "FİRMA ADRESİ")
                    
                    Abilities(text: $companyPhone, desc: "FİRMA TELEFONU", keyStyle: .phone)
                    
                    Abilities(text: $workName, desc: "İŞ İSMİ")
                    
                    Abilities(text: $workDesc, desc: "İŞ AÇIKLAMA")
                    
                    Abilities(text: $workPrice, desc: "İŞ FİYATI", keyStyle: .numaric)

                    HStack(spacing: 10) {
                        Abilities(text: $workRec, desc: "ALINAN", keyStyle: .numaric)
                        
                        Abilities(text: $workRem, desc: "KALAN", keyStyle: .numaric, isWorkRem: true)
                            .onChange(of: workPrice) { oldValue, newValue in
                                workRem = "\((Double(workPrice) ?? 0) - (Double(workRec) ?? 0))"
                            }
                            .onChange(of: workRec) { oldValue, newValue in
                                workRem = "\((Double(workPrice) ?? 0) - (Double(workRec) ?? 0))"
                            }
                    }
                    
                    AbilitiesDatePicker(date: $workStTime, isPickerShower: $isPickerShower, pickerSelector: $pickerSelector, desc: "BAŞLAMA TARİHİ")
                    
                    AbilitiesDatePicker(date: $workFnTime, isPickerShower: $isPickerShower, pickerSelector: $pickerSelector, desc: "TAHMİNİ BİTİŞ TARİHİ")
             
                }
                .offset(y: isPickerShower ? -300 : 0)
                .padding(.bottom, 20)
                
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .padding(.horizontal)
        .overlay(alignment: .bottom) {
            CustomDatePicker(date: pickerSelector == .stPicker ? $workStTime : $workFnTime )
                .offset(y: isPickerShower ? 0 : 400)
        }
        
    }
    
    @ViewBuilder
    func CustomDatePicker(date: Binding<Date>) -> some View {
        VStack {
            DatePicker("", selection: date, displayedComponents: .date)
                .colorScheme(.light)
                .datePickerStyle(WheelDatePickerStyle())
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke(style: .init(lineWidth: 1))
                        .fill(.black.opacity(0.7))
                        .shadow(color: .black, radius: 10, y: 5)
                }
                .padding([.horizontal, .top])
            
                
            Button {
                withAnimation(.snappy) {
                    isPickerShower = false
                }
            } label: {
                Text("SEÇ")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .background(.BG)
                    .clipShape( RoundedRectangle(cornerRadius: 5, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(style: StrokeStyle(lineWidth: 1))
                            .foregroundStyle(.black)
                    }
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.bottom)

        }
        .background(.white)
    }
}

struct TestGapNote : View {
    @State private var isAddWork = false
    @State private var companyViewModel: CompanyViewModel
    
    init(modelContext: ModelContext) {
        UITabBar.appearance().isHidden = true
        let companyViewModel = CompanyViewModel(modelContext: modelContext)
        _companyViewModel = State(initialValue: companyViewModel)
        
    }
    
    var body: some View {
        Note(companyViewModel: $companyViewModel, isAddWork: $isAddWork)
    }
}

struct TestNote : View {
    
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Company.self)
        } catch {
            fatalError("Failed to create ModelContainer for Game.")
        }
    }
    
    var body: some View {
        TestGapNote(modelContext: container.mainContext)
            .modelContainer(container)
    }
}

#Preview {
    TestNote()
}

enum KeyboardStyle {
    case numaric, text, phone
}

