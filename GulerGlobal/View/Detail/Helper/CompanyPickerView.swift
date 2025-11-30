//
//  CompanyPickerView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 28.10.2025.
//

import SwiftUI

struct CompanyPickerView: View {
    @StateObject private var viewModel: CompanyPickerViewModel
    init(
        companyList: [Company],
        title: FormTitle,
        filter: PartnerRole,
        formTitle: Binding<FormTitle>,
        hiddingAnimation: Binding<Bool>,
        company: Binding<Company?>) {
        _viewModel = StateObject(wrappedValue: CompanyPickerViewModel(
            companyList: companyList,
            title: title,
            filter: filter,
            formTitle: formTitle,
            hiddingAnimation: hiddingAnimation,
            company: company
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 5){
                TextField("", text: $viewModel.text)
                    .placeholder(when: viewModel.text.isEmpty, padding: 0) {
                        Text("Firma Girin")
                            .foregroundColor(.gray)
                    }
                    .disabled(viewModel.isHidden)
                    .padding(20)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.init(degrees: viewModel.isHidden ? 180 : 0))
                    .onTapGesture {
                        viewModel.selectedCompany()
                    }
                    .padding(10)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .circular))
            }
            .foregroundStyle(Color.accentColor)
            .font(.title3)
            .padding(10)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.companies == [] ? viewModel.companyList.filter { $0.partnerRole == .both || $0.partnerRole == viewModel.filter} : viewModel.companies, id: \.self) { c in
                        Text("-> \(c.name)")
                            .padding(10)
                            .onTapGesture {
                                viewModel.text = c.name
                                viewModel.company = c
                                viewModel.selectedCompany()
                            }
                            .foregroundStyle(.gray)
                            .font(.headline)
                        
                        Divider()
                    }
                }
            }
            .frame(height: viewModel.isHidden ? 0 : 500)
            .padding(.leading, 20)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
            .clipShape(.rect(cornerRadius: 30, style: .continuous))
        }
        .onChange(of: viewModel.text) { _, newValue in
            viewModel.searching(value: newValue)
        }
        .onChange(of: viewModel.isHidden) { _, _ in
            if let company = viewModel.company {
                viewModel.text = company.name
            } else {
                viewModel.text = ""
            }
        }
        .frame(maxWidth: .infinity)
        .font(.caption)
        .fontWeight(.semibold)
        .padding(.horizontal, 5)
        .animation(.linear, value: viewModel.isHidden)
    }
}

final class CompanyPickerViewModel: ObservableObject {
    @Published var isHidden: Bool = true
    @Published var text: String = ""
    @Published var companies: [Company] = []
    let companyList: [Company]
    let title: FormTitle
    let filter: PartnerRole
    @Binding var formTitle: FormTitle
    @Binding var hiddingAnimation: Bool
    @Binding var company: Company?
    
    init(companyList: [Company], title: FormTitle,filter: PartnerRole, formTitle: Binding<FormTitle>, hiddingAnimation: Binding<Bool>, company: Binding<Company?>) {
        self.companyList = companyList
        self.title = title
        self.filter = filter
        _formTitle = formTitle
        _hiddingAnimation = hiddingAnimation
        _company = company
    }
    
    func searchCompanies(by name: String) -> [Company]? {
        guard !name.isEmpty else { return nil }
        return companyList.filter { $0.name.lowercased().hasPrefix(name.lowercased()) }
    }
    
    func searching(value: String) {
        if value == "" {
            self.companies = []
        } else {
            if let searchCompany = searchCompanies(by: text) {
                self.companies = searchCompany.filter { $0.partnerRole == .both || $0.partnerRole == .current}
            }
        }
    }
    
    func selectedCompany() {
        if isHidden {
            formTitle = title
        } else {
            formTitle = .none
        }
        
        isHidden.toggle()
        hiddingAnimation.toggle()
    }
}
