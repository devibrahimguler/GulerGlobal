//
//  WorkEntryView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI


struct WorkEntryView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: MainViewModel
    @State private var activeField: FormTitle = .none
    @State private var hiddingAnimation: Bool = false
    
    @State private var startConfig: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    @State private var endConfig: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    
    
    @Binding var company: Company?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                CompanyPickerView(title: .companyName, filter: .current, formTitle: $activeField, hiddingAnimation: $hiddingAnimation, company: $company)
                
                CustomTextField(
                    title: .projeNumber,
                    text: $viewModel.workDetails.id,
                    formTitle: $activeField,
                    keyboardType: .numberPad,
                    color: viewModel.workDetails.isChangeProjeNumber ? .black : .gray
                )
                .disabled(!viewModel.workDetails.isChangeProjeNumber)
                .onTapGesture {
                    withAnimation(.snappy) {
                        viewModel.workDetails.isChangeProjeNumber.toggle()
                    }
                }
                
                CustomTextField(title: .workName, text: $viewModel.workDetails.name, formTitle: $activeField)
                
                CustomTextField(title: .workDescription, text: $viewModel.workDetails.description, formTitle: $activeField)
                
                CustomTextField(title: .workPrice, text: $viewModel.workDetails.cost, formTitle: $activeField, keyboardType: .numberPad)
                
                CustomDatePicker(dateConfig: $startConfig, title: .startDate, formTitle: $activeField)
                    .foregroundStyle(.isText)
                
                CustomDatePicker(dateConfig: $endConfig, title: .finishDate, formTitle: $activeField)
                    .foregroundStyle(.isText)
            }
            .padding(10)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20, style: .continuous))
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .animation(.linear, value: hiddingAnimation)
        .background(colorScheme == .light ? Color.gray.opacity(0.2) : Color.white.opacity(0.2))
        .onAppear {
            viewModel.workDetails.id = viewModel.generateUniqueID()
            startConfig = dateToConfig(viewModel.workDetails.startDate)
            endConfig = dateToConfig(viewModel.workDetails.endDate)
        }
        .animation(.snappy, value: activeField)
        .onDisappear {
            activeField = .none
            company = nil
            viewModel.updateWorkDetails(with: nil)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Onayla") {
                    handleWorkSubmission()
                }
                .foregroundStyle(.isGreen)
                .font(.headline)
                .fontWeight(.semibold)
            }
        }
        
    }
    
    private func handleWorkSubmission() {
        guard let company = company,
              !viewModel.workDetails.id.isEmpty,
              !viewModel.workDetails.name.isEmpty,
              !viewModel.workDetails.description.isEmpty,
              !viewModel.workDetails.cost.isEmpty else { return }
        
        viewModel.workDetails.status = .pending
        
        let newWork = Work(
            id: viewModel.workDetails.id,
            companyId: company.id,
            name: viewModel.workDetails.name,
            description: viewModel.workDetails.description,
            cost: viewModel.workDetails.cost.toDouble(),
            status: viewModel.workDetails.status,
            startDate: configToDate(startConfig),
            endDate: configToDate(endConfig)
        )
        
        viewModel.createWork(work: newWork)
        dismiss()
    }
}


struct Test_WorkEntryView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @State private var company: Company?
    var body: some View {
        WorkEntryView(company: $company)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_WorkEntryView()
        .preferredColorScheme(.dark)
}

struct CompanyPickerView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isHidden: Bool = true
    @State private var text: String = ""
    @State private var companies: [Company] = []
    
    var title: FormTitle
    var filter: CompanyStatus
    @Binding var formTitle: FormTitle
    @Binding var hiddingAnimation: Bool
    @Binding var company: Company?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 5){
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty, padding: 0) {
                        Text("Firma Girin")
                            .foregroundColor(.gray)
                    }
                    .disabled(isHidden)
                    .padding(20)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.init(degrees: isHidden ? 180 : 0))
                    .onTapGesture {
                        selectedCompany()
                    }
                    .padding(10)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .circular))
            }
            .foregroundStyle(Color.accentColor)
            .font(.title3)
            .padding(10)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(companies == [] ? viewModel.companyList.filter { $0.status == .both || $0.status == filter} : companies, id: \.self) { c in
                        Text("-> \(c.name)")
                            .padding(10)
                            .onTapGesture {
                                text = c.name
                                company = c
                                selectedCompany()
                            }
                            .foregroundStyle(.gray)
                            .font(.headline)
                        
                        Divider()
                    }
                }
            }
            .frame(height: isHidden ? 0 : 500)
            .padding(.leading, 20)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
            .clipShape(.rect(cornerRadius: 30, style: .continuous))
        }
        .onChange(of: text) { _, newValue in
            searching(value: newValue)
        }
        .onChange(of: isHidden) { _, _ in
            if let company = company {
                self.text = company.name
            } else {
                self.text = ""
            }
        }
        .frame(maxWidth: .infinity)
        .font(.caption)
        .fontWeight(.semibold)
        .padding(.horizontal, 5)
        .animation(.linear, value: isHidden)
    }
    
    func searching(value: String) {
        if value == "" {
            self.companies = []
        } else {
            if let searchCompany = viewModel.searchCompanies(by: text) {
                self.companies = searchCompany.filter { $0.status == .both || $0.status == .current}
            }
        }
    }
    
    private func selectedCompany() {
        if isHidden {
            formTitle = title
        } else {
            formTitle = .none
        }
        
        isHidden.toggle()
        hiddingAnimation.toggle()
    }
}
