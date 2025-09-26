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
    @State private var openMenu: Bool = false
    
    var tuple: TupleModel
    var isBidView: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                
                VStack(spacing: 5) {
                    CustomTextField(title: .workName, text: $viewModel.workDetails.name, formTitle: $formTitle)
                        .disabled(!isEditWork)
                    
                    CustomTextField(title: .workDescription, text: $viewModel.workDetails.description, formTitle: $formTitle)
                        .disabled(!isEditWork)
                    
                    HStack {
                        CustomTextField(title: .workPrice, text: $viewModel.workDetails.totalCost, formTitle: $formTitle)
                            .disabled(!isEditWork)
                        
                        if !(tuple.work.approve == .finished) {
                            if tuple.work.remainingBalance == 0 {
                                Button {
                                    withAnimation(.snappy) {
                                        viewModel.updateWork(
                                            companyId: tuple.company.id,
                                            workId: tuple.work.id,
                                            updateArea: ["approve": ApprovalStatus.finished.rawValue]
                                        )
                                        
                                    }
                                } label: {
                                    Text("Bitti")
                                        .font(.title)
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.accentColor)
                                }
                                .padding(10)
                                .background(.isGreen.gradient)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(lineWidth: 4)
                                        .fill(Color.isSkyBlue.gradient)
                                }
                                .opacity(isEditWork ? 0 : 1)
                            } else {
                                CustomTextField(title: .remMoney, text: $viewModel.acceptRem, formTitle: $formTitle, color: .red)
                                    .disabled(true)
                            }
                        }
                        
                    }
                }
                .scaleEffect(x: isEditWork ? 0.97 : 1, y: isEditWork ? 0.97 : 1)
                .animation(isEditWork ? .easeInOut(duration: 0.5).repeatForever() : .easeInOut(duration: 0.5), value: isEditWork)
                .padding(10)
                .background(.background, in: .rect(cornerRadius: 20))
                
                
                VStack(spacing: 5) {
                    CustomDatePicker(dateConfig: $startConfig, title: .startDate, activeTitle: $formTitle)
                    
                    CustomDatePicker(dateConfig: $endConfig, title: .finishDate, activeTitle: $formTitle)
                }
                .foregroundStyle(.isText)
                .disabled(!isEditWork)
                .scaleEffect(x: isEditWork ? 0.97 : 1, y: isEditWork ? 0.97 : 1)
                .animation(isEditWork ? .easeInOut(duration: 0.5).repeatForever() : .easeInOut(duration: 0.5), value: isEditWork)
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
                .opacity(
                    isEditWork ||
                    tuple.work.approve == .pending ? 0 : 1)
                .animation(.linear, value: hiddingAnimation)
            }
        }
        .navigationTitle("Guler Global")
        .padding(.horizontal, 10)
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2))
        .blur(radius: openMenu ? 5 : 0)
        .disabled(openMenu)
        .overlay(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    withAnimation(.spring) {
                        viewModel.updateWorkDetails(with: tuple.work)
                        formTitle = .none
                        openMenu = false
                        isEditWork.toggle()
                    }
                } label: {
                    if isEditWork {
                        Label("İptal", systemImage: "pencil.slash")
                    } else {
                        Label("Düzenle", systemImage: "square.and.pencil")
                    }
                }
                
                if isEditWork {
                    Button {
                        withAnimation(.spring) {
                            viewModel.acceptRem = "\(viewModel.remMoneySnapping(price: viewModel.workDetails.totalCost.toDouble(), statements: tuple.work.statements))"
                            
                            let workName = viewModel.workDetails.name.trim()
                            let workDescription = viewModel.workDetails.description.trim()
                            
                            let updateArea = [
                                "workName": workName,
                                "workDescription": workDescription,
                                "totalCost": viewModel.workDetails.totalCost.toDouble(),
                                "remainingBalance": viewModel.acceptRem.toDouble(),
                                "startDate": configToDate(startConfig),
                                "endDate": configToDate(endConfig),
                            ]
                            
                            viewModel.updateWork(companyId: tuple.company.id, workId: tuple.work.id, updateArea: updateArea)
                            viewModel.updateWorkDetails(with: nil)
                            
                            formTitle = .none
                            openMenu = false
                            isEditWork.toggle()
                        }
                    } label: {
                        Label("Kaydet", systemImage: "pencil.line")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.ultraThickMaterial)
            .offset(y: openMenu ? 0 : 300)
            
        }
        .animation(.linear, value: openMenu)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    hideKeyboard()
                    openMenu.toggle()
                } label: {
                    Image(systemName: openMenu ? "xmark" : "filemenu.and.selection")
                        .contentTransition(.symbolEffect(.replace.magic(fallback: .offUp.wholeSymbol), options: .nonRepeating))
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
            viewModel.updateWorkDetails(with: nil)
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

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
