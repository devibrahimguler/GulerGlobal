//
//  WorkDetailView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 22.09.2024.
//

import SwiftUI

struct WorkDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: MainViewModel
    
    @State private var startConfig: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    @State private var endConfig: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    
    @State private var isEditWork: Bool = false
    @State private var formTitle: FormTitle = .none
    
    @State private var addType: ListType = .none
    @State private var isAdd: Bool = false
    @State private var hiddingAnimation: Bool = false
    
    var tuple: TupleModel
    var isBidView: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                
                 VStack(spacing: 5) {
                     CustomTextField(title: .workName, text: $viewModel.workDetails.name, formTitle: $formTitle)
                     
                     CustomTextField(title: .workDescription, text: $viewModel.workDetails.description, formTitle: $formTitle)
                     
                     HStack {
                         CustomTextField(title: .workPrice, text: $viewModel.workDetails.totalCost, formTitle: $formTitle)
                         
                         if !(tuple.work.approve == .finished) {
                             if tuple.work.remainingBalance == 0 {
                                 if !isEditWork {
                                     VStack {
                                         Text("BİTTİ")
                                             .foregroundStyle(.red)
                                             .padding(5)
                                             .background(.white)
                                             .foregroundStyle(.gray)
                                             .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                             .overlay {
                                                 RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                     .stroke(style: .init(lineWidth: 3))
                                                     .fill(.red)
                                             }
                                             .zIndex(1)
                                             .padding(.horizontal, 5)
                                         
                                         Button {
                                             viewModel.updateWork(
                                                companyId: tuple.company.id,
                                                workId: tuple.work.id,
                                                updateArea: ["approve": ApprovalStatus.finished.rawValue]
                                             )
                                         } label: {
                                             Image(systemName: "square")
                                                 .font(.system(size: 20, weight: .bold, design: .monospaced))
                                                 .foregroundStyle(.red)
                                         }
                                     }
                                     .padding(.horizontal, 5)
                                     .font(.system(size: 15, weight: .black, design: .monospaced))
                                 }
                             } else {
                                 CustomTextField(title: .remMoney, text: $viewModel.acceptRem, formTitle: $formTitle, color: .red)
                                     .disabled(true)
                             }
                         }
                         
                     }
                 }
                 .disabled(!isEditWork)
                 .scaleEffect(x: isEditWork ? 0.97 : 1, y: isEditWork ? 0.97 : 1)
                 .animation(.easeInOut(duration: 0.5).repeatForever(), value: isEditWork)
                 .padding(10)
                 .background(.background, in: .rect(cornerRadius: 20))

                 
                 VStack(spacing: 5) {
                     CustomDatePicker(dateConfig: $startConfig, title: .startDate, activeTitle: $formTitle)
                     
                     CustomDatePicker(dateConfig: $endConfig, title: .finishDate, activeTitle: $formTitle)
                 }
                 .foregroundStyle(isEditWork ? .black : .gray)
                 .disabled(!isEditWork)
                 .scaleEffect(x: isEditWork ? 0.97 : 1, y: isEditWork ? 0.97 : 1)
                 .animation(.easeInOut(duration: 0.5).repeatForever(), value: isEditWork)
                 .padding(10)
                 .background(.background, in: .rect(cornerRadius: 20))
                 
                VStack(spacing: 5) {
                    
                    StatementListView(
                       title: "Alınan Paralar",
                       status: .received,
                       list: tuple.work.statements.filter { $0.status == .received },
                       tuple: tuple,
                       hiddingAnimation: $hiddingAnimation
                    )
                    
                    StatementListView(
                       title: "Alınacak Paralar",
                       status: .expired,
                       list: tuple.work.statements.filter { $0.status == .expired },
                       tuple: tuple,
                       hiddingAnimation: $hiddingAnimation
                    )
                    
                    ProductListView(
                        title: "Malzeme Listesi",
                        list: tuple.work.productList,
                        tuple: tuple,
                        hiddingAnimation: $hiddingAnimation
                    )
                }
                .opacity(isEditWork ? 0 : 1)
                .animation(.linear, value: hiddingAnimation)
            }
        }
        .navigationTitle("Guler Global")
        .padding(.horizontal, 10)
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring) {
                        if isEditWork {
                            viewModel.acceptRem = "\(viewModel.remMoneySnapping(price: viewModel.workDetails.totalCost.toDouble(), statements: tuple.work.statements))"
                            
                            let updateArea = [
                                "workName": viewModel.workDetails.name,
                                "workDescription": viewModel.workDetails.description,
                                "totalCost": viewModel.workDetails.totalCost.toDouble(),
                                "remainingBalance": viewModel.acceptRem.toDouble(),
                                "startDate": configToDate(startConfig),
                                "endDate": configToDate(endConfig),
                            ]
                            
                            viewModel.updateWork(companyId: tuple.company.id, workId: tuple.work.id, updateArea: updateArea)
                            viewModel.updateWorkDetails(with: nil)
                        } else {
                            viewModel.updateWorkDetails(with: tuple.work)
                        }
                        
                        formTitle = .none
                        isEditWork.toggle()
                    }
                }
                label: {
                    Text(isEditWork ? "Kaydet" : "Düzenle")
                        .foregroundStyle(isEditWork ? .green : .yellow)
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                }
            }
        }
         .onAppear {
             viewModel.updateWorkDetails(with: tuple.work)
             startConfig = dateToConfig(viewModel.workDetails.startDate)
             endConfig = dateToConfig(viewModel.workDetails.endDate)
             viewModel.acceptRem = "\(viewModel.remMoneySnapping(price: tuple.work.totalCost, statements: tuple.work.statements))"
         }
         .onDisappear {
             viewModel.updateWorkDetails(with: tuple.work)
         }
         .onChange(of: isAdd) { oldValue, newValue in
             addType = addType
         }
         .onChange(of: viewModel.workDetails.totalCost) { oldValue, newValue in
             if newValue != "0" {
                 viewModel.acceptRem = "\(viewModel.remMoneySnapping(price: newValue.toDouble(), statements: tuple.work.statements))"
             }
         }
    }
}

struct Test_WorkDetailView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        WorkDetailView(tuple: example_TupleModel)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_WorkDetailView()
}

func configToDate(_ config: DateConfig) -> Date {
    var components = DateComponents()
    components.day = Int(config.selectedDay) ?? 1
    components.month = getMonthIndex(for: config.selectedMonth) ?? 1
    components.year = Int(config.selectedYear) ?? 1
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "tr_TR")
    let date = Calendar.current.date(from: components) ?? .now
    return date
}

func dateToConfig(_ date: Date) -> DateConfig {
    let components = date.get(.day, .month, .year)
    var config = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "1"
    )
    if let day = components.day, let month = components.month, let year = components.year {
        config.selectedDay = String(day)
        config.selectedMonth = getMonthName(for: month)
        config.selectedYear = String(year)
    }

    return config
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
