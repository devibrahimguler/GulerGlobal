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
            VStack(spacing: 8) {
                CompanyPickerView(title: .companyName, activeField: $activeField, hiddingAnimation: $hiddingAnimation, company: $company)
                
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
                
                CustomTextField(title: .workPrice, text: $viewModel.workDetails.totalCost, formTitle: $activeField, keyboardType: .numberPad)
                
                CustomDatePicker(dateConfig: $startConfig, title: .startDate, activeTitle: $activeField)
                
                CustomDatePicker(dateConfig: $endConfig, title: .finishDate, activeTitle: $activeField)
                
                Button("Onayla") {
                    handleWorkSubmission()
                }
                .foregroundColor(.isText)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(10)
                .background(.isGreen, in: .rect(cornerRadius: 10))
                .padding(5)
            }
            .padding(10)
            .background(.background, in: .rect(cornerRadius: 20))
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
        
    }
    
    private func handleWorkSubmission() {
        guard let company = company,
              !viewModel.workDetails.id.isEmpty,
              !viewModel.workDetails.name.isEmpty,
              !viewModel.workDetails.description.isEmpty,
              !viewModel.workDetails.totalCost.isEmpty else { return }
        
        viewModel.workDetails.approve = .pending
        
        let newWork = Work(
            id: viewModel.workDetails.id,
            workName: viewModel.workDetails.name,
            workDescription: viewModel.workDetails.description,
            totalCost: viewModel.workDetails.totalCost.toDouble(),
            approve: viewModel.workDetails.approve,
            remainingBalance: viewModel.workDetails.totalCost.toDouble(),
            statements: [],
            startDate: configToDate(startConfig),
            endDate: configToDate(endConfig),
            productList: [])
        
        viewModel.createWork(companyId: company.id, work: newWork)
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
    @Binding var activeField: FormTitle
    @Binding var hiddingAnimation: Bool
    @Binding var company: Company?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0){
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty, padding: 0) {
                        Text("Firma Girin")
                            .foregroundColor(.gray)
                    }
                    .disabled(isHidden)
                
                // Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.init(degrees: isHidden ? 180 : 0))
                    .onTapGesture {
                        selectedCompany()
                    }
            }
            .foregroundStyle(Color.accentColor)
            .font(.title3)
            .padding(10)
            
            Divider()
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(companies == [] ? viewModel.companyList.filter { $0.partnerRole == .both || $0.partnerRole == .current} : companies, id: \.self) { c in
                        Text("-> \(c.companyName)")
                            .padding(10)
                            .onTapGesture {
                                text = c.companyName
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
        }
        .onChange(of: text) { _, newValue in
            searching(value: newValue)
        }
        .onChange(of: isHidden) { _, _ in
            if let company = company {
                self.text = company.companyName
            } else {
                self.text = ""
            }
        }
        .frame(maxWidth: .infinity)
        .font(.caption)
        .fontWeight(.semibold)
        .background(Color.white)
        .clipShape(RoundedCorner(radius: 10, corners: .allCorners))
        .overlay {
            RoundedCorner(radius: 10, corners: .allCorners)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .fill(
                    activeField == title ?
                    Color.accentColor.gradient :
                        company != nil ?
                    Color.isGreen.gradient :
                        Color.isSkyBlue.gradient)
        }
        .padding(.horizontal, 5)
        .animation(.linear, value: isHidden)
    }
    
    func searching(value: String) {
        if value == "" {
            self.companies = []
        } else {
            if let searchCompany = viewModel.searchCompanies(by: text) {
                self.companies = searchCompany.filter { $0.partnerRole == .both || $0.partnerRole == .current}
            }
        }
    }
    
    private func selectedCompany() {
        if isHidden {
            activeField = title
        } else {
            activeField = .none
        }
        
        isHidden.toggle()
        hiddingAnimation.toggle()
    }
}
