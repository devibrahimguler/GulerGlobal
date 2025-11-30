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
    
    @State private var hiddingAnimation: Bool = false
    @State private var openMenu: Bool = false
    
    var tuple: TupleModel
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                
                VStack(spacing: 0) {
                    CustomTextField(title: .workName, text: $viewModel.workDetails.name, formTitle: $formTitle)
                        .disabled(!isEditWork)
                    
                    CustomTextField(title: .workDescription, text: $viewModel.workDetails.description, formTitle: $formTitle)
                        .disabled(!isEditWork)
                    
                    CustomTextField(title: .workPrice, text: $viewModel.workDetails.cost, formTitle: $formTitle)
                        .disabled(!isEditWork)
                }
                .scaleEffect(x: isEditWork ? 0.97 : 1, y: isEditWork ? 0.97 : 1)
                .animation(isEditWork ? .easeInOut(duration: 0.5).repeatForever() : .easeInOut(duration: 0.5), value: isEditWork)
                .padding(10)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                
                VStack(spacing: 0) {
                    CustomDatePicker(dateConfig: $startConfig, title: .startDate, formTitle: $formTitle)
                    
                    CustomDatePicker(dateConfig: $endConfig, title: .finishDate, formTitle: $formTitle)
                }
                .foregroundStyle(.isText)
                .disabled(!isEditWork)
                .scaleEffect(x: isEditWork ? 0.97 : 1, y: isEditWork ? 0.97 : 1)
                .animation(isEditWork ? .easeInOut(duration: 0.5).repeatForever() : .easeInOut(duration: 0.5), value: isEditWork)
                .padding(10)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                VStack(spacing: 5) {
                    
                    ProductListView(
                        title: "Malzeme Listesi",
                        //// hata
                        list: example_ProductList,
                        company: tuple.company,
                        workId: tuple.work.id,
                        isSupplier: false,
                        hiddingAnimation: $hiddingAnimation
                    )
                    
                }
                .opacity(
                    // tuple.work.productList.isEmpty ||
                    isEditWork ||
                    tuple.work.status == .pending ? 0 : 1)
                .animation(.linear, value: hiddingAnimation)
            }
            .padding(.horizontal, 10)
        }
        .navigationTitle(tuple.company.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2))
        .blur(radius: openMenu ? 5 : 0)
        .disabled(openMenu)
        .overlay(alignment: .bottom) {
            WorkMenu(
                isEdit: $isEditWork,
                formTitle: $formTitle,
                openMenu: $openMenu,
                startConfig: $startConfig,
                endConfig: $endConfig,
                tuple: tuple
            )
            .environmentObject(viewModel)
            .offset(y: openMenu ? 0 : 500)
        }
        .animation(.linear, value: openMenu)
        .navigationBarBackButtonHidden(openMenu || isEditWork)
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
        }
        .onDisappear {
            viewModel.updateWorkDetails(with: nil)
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

struct WorkMenu: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: MainViewModel
    @Binding var isEdit: Bool
    @Binding var formTitle: FormTitle
    @Binding var openMenu: Bool
    @Binding var startConfig: DateConfig
    @Binding var endConfig: DateConfig
    
    var tuple: TupleModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Button {
                withAnimation(.spring) {
                    viewModel.updateWorkDetails(with: tuple.work)
                    formTitle = .none
                    openMenu = false
                    isEdit.toggle()
                }
            } label: {
                if isEdit {
                    Label("İptal", systemImage: "pencil.slash")
                } else {
                    Label("Düzenle", systemImage: "square.and.pencil")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
            .padding(.horizontal, 20)
            
            if isEdit {
                Button {
                    withAnimation(.spring) {
                        let updateArea = [
                            "name": viewModel.workDetails.name.trim(),
                            "description": viewModel.workDetails.description.trim(),
                            "cost": viewModel.workDetails.cost.toDouble(),
                            "startDate": configToDate(startConfig),
                            "endDate": configToDate(endConfig),
                        ]
                        viewModel.updateWork(
                            workId: tuple.work.id,
                            updateArea: updateArea
                        )
                        
                        viewModel.updateWorkDetails(with: nil)
                        formTitle = .none
                        openMenu = false
                        isEdit.toggle()
                        
                        dismiss()
                    }
                    
                } label: {
                    Label("Kaydet", systemImage: "pencil.line")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 20)
            }
            else
            {
                if tuple.work.status == .approved {
                    Button {
                        withAnimation(.snappy) {
                            viewModel.updateWork(
                                workId: tuple.work.id,
                                updateArea: ["status": ApprovalStatus.finished.rawValue]
                            )
                            
                            dismiss()
                        }
                    } label: {
                        Label("İş Bitti", systemImage: "checkmark.app")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                    .padding(.horizontal, 20)
                    
                    NavigationLink {
                        ProductEntryView(companyId: tuple.company.id, workId: tuple.work.id, isSupplier: false)
                            .environmentObject(viewModel)
                    } label: {
                        Label("Malzeme Ekle", systemImage: "plus.viewfinder")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                    .padding(.horizontal, 20)
                }
            }
            
        }
    }
}
