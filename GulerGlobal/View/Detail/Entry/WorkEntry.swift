//
//  WorkEntry.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI


struct WorkEntry: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: MainViewModel
    @State private var activeField: FormTitle = .none
    @State private var isClicked: Bool = false
    
    @State private var hiddingAnimation: Bool = false
    
    @State private var startConfig: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    @State private var endConfig: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    
    
    var company: Company
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                CustomTextField(
                    title: .projeNumber,
                    text: $viewModel.workVM.workDetails.id,
                    formTitle: $activeField,
                    keyboardType: .numberPad,
                    color: viewModel.workVM.workDetails.isChangeProjeNumber ? .black : .gray
                )
                .disabled(!viewModel.workVM.workDetails.isChangeProjeNumber)
                .onTapGesture {
                    withAnimation(.snappy) {
                        viewModel.workVM.workDetails.isChangeProjeNumber.toggle()
                    }
                }
                
                CustomTextField(title: .workName, text: $viewModel.workVM.workDetails.name, formTitle: $activeField)
                
                CustomTextField(title: .workDescription, text: $viewModel.workVM.workDetails.description, formTitle: $activeField)
                
                CustomTextField(title: .workPrice, text: $viewModel.workVM.workDetails.cost, formTitle: $activeField, keyboardType: .numberPad)
                
                CustomDatePicker(dateConfig: $startConfig, title: .startDate, formTitle: $activeField)
                    .foregroundStyle(.isText)
                
                CustomDatePicker(dateConfig: $endConfig, title: .finishDate, formTitle: $activeField)
                    .foregroundStyle(.isText)
            }
            .padding(.vertical)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .animation(.linear, value: hiddingAnimation)
        .onAppear {
            viewModel.workVM.workDetails.id = viewModel.workVM.generateUniqueID()
            startConfig = viewModel.workVM.workDetails.startDate.dateToConfig()
            endConfig = viewModel.workVM.workDetails.endDate.dateToConfig()
        }
        .animation(.snappy, value: activeField)
        .onDisappear {
            activeField = .none
            viewModel.workVM.updateDetails(with: nil)
        }
        .toolbar {
            CustomItem(title: "Onayla", icon: "checkmark", isClicked: isClicked) {
                submission()
            }
        }
        
    }
    
    private func submission() {
        isClicked = true
        
        guard !viewModel.workVM.workDetails.id.isEmpty,
              !viewModel.workVM.workDetails.name.isEmpty,
              !viewModel.workVM.workDetails.description.isEmpty,
              !viewModel.workVM.workDetails.cost.isEmpty
        else {
            isClicked = false
            return
        }
        
        viewModel.workVM.workDetails.status = .pending
        
        let newWork = Work(
            id: viewModel.workVM.workDetails.id,
            companyId: company.id,
            name: viewModel.workVM.workDetails.name,
            description: viewModel.workVM.workDetails.description,
            cost: viewModel.workVM.workDetails.cost.toDouble(),
            left: viewModel.workVM.workDetails.cost.toDouble(),
            status: viewModel.workVM.workDetails.status,
            startDate: startConfig.configToDate(),
            endDate: endConfig.configToDate()
        )
        
        viewModel.workVM.create(work: newWork, setLoading: viewModel.setLoading)
        
        isClicked = false
        dismiss()
    }
}


struct Test_WorkEntry: View {
    @StateObject private var viewModel: MainViewModel = .init()
    var company: Company = example_Company
    var body: some View {
        WorkEntry(company: company)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_WorkEntry()
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
                    ForEach(companies == [] ? viewModel.companyVM.companies.filter { $0.status == .both || $0.status == filter} : companies, id: \.self) { c in
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
            if let searchCompany = viewModel.companyVM.search(by: text) {
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

struct SupplierPickerView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isHidden: Bool = true
    @State private var text: String = ""
    @State private var companies: [Company] = []
    
    var title: FormTitle
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
                    ForEach(companies == [] ? viewModel.companyVM.companies.filter { $0.status == .both || $0.status == .supplier} : companies, id: \.self) { c in
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
            if let searchCompany = viewModel.companyVM.search(by: text) {
                self.companies = searchCompany.filter { $0.status == .both || $0.status == .supplier}
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
