//
//  CompanyDetail.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 14.02.2024.
//

import SwiftUI

struct CompanyDetail: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditCompany: Bool = false
    @State private var formTitle: FormTitle = .none
    
    @State private var addType: ListType = .none
    @State private var isReset: Bool = false
    @State private var openMenu: Bool = false
    @State private var hiddingAnimation: Bool = false
    
    @ObservedObject var viewModel: MainViewModel
    var company: Company
    var companyStatus: CompanyStatus
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                
                VStack(spacing: 0) {
                    CustomTextField(title: .companyName, text: $viewModel.companyVM.companyDetails.name, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                    
                    CustomTextField(title: .companyAddress, text: $viewModel.companyVM.companyDetails.address, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                    
                    CustomTextField(title: .companyPhone, text: $viewModel.companyVM.companyDetails.phone, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                    
                }
                .scaleEffect(x: isEditCompany ? 0.97 : 1, y: isEditCompany ? 0.97 : 1)
                .animation(isEditCompany ? .easeInOut(duration: 0.5).repeatForever() : .easeInOut(duration: 0.5), value: isEditCompany)
                .padding(.top, 25)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                if !isEditCompany && companyStatus != .debt {
                    editCompanyView()
                }
                
                 VStack(spacing: 10) {
                     let works = viewModel.workVM.works.filter { $0.companyId == company.id }.sorted { $0.id > $1.id }
                     let products = viewModel.companyProductVM.companyProducts.filter { $0.companyId == company.id }.sorted { $0.date > $1.date }
                     let statements = viewModel.statementVM.statements.filter { $0.companyId == company.id }.sorted { $0.date > $1.date }
                     
                     if !works.isEmpty && companyStatus != .debt {
                         WorkListView(
                             title: "İş Listesi",
                             list: works,
                             company: company,
                             hiddingAnimation: $hiddingAnimation
                         )
                         .environmentObject(viewModel)
                     }
                     
                     if !statements.isEmpty {
                         StatementListView (
                             title: "Finans Kayıtları",
                             list: statements,
                             company: company,
                             hiddingAnimation: $hiddingAnimation
                         )
                         .environmentObject(viewModel)
                     }
                     
                     if !products.isEmpty && companyStatus != .debt {
                         CompanyProductList(
                             title: "Malzeme Listesi",
                             list: products,
                             company: company,
                             hiddingAnimation: $hiddingAnimation
                         )
                         .environmentObject(viewModel)
                     }
                     
                 }
                 .opacity(isEditCompany ? 0 : 1)
                
            }
            .padding(.horizontal, 20)
            
        }
        .navigationTitle(company.name)
        .navigationBarTitleDisplayMode(.inline)
        .blur(radius: openMenu ? 5 : 0)
        .disabled(openMenu)
        .overlay(alignment: .bottom) {
             CompanyMenu(
                 isEdit: $isEditCompany,
                 formTitle: $formTitle,
                 openMenu: $openMenu,
                 company: company
             )
             .environmentObject(viewModel)
             .offset(y: openMenu ? 0 : 1000)
        }
        .navigationBarBackButtonHidden(openMenu || isEditCompany)
        .animation(.linear, value: openMenu)
        .toolbar {
            if companyStatus != .debt {
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
        }
        .onAppear {
            viewModel.companyVM.updateDetails(with: company)
        }
        .onDisappear {
            viewModel.companyVM.updateDetails(with: nil)
        }
        
    }
    
    func cashRoleValue(_ value: CompanyStatus) -> String {
        switch value {
        case .current:
            return "Cari"
        case .supplier:
            return "Tedarikçi"
        case .both:
            return "Birleşik"
        case .debt:
            return "Borç"
        }
    }
    
    @ViewBuilder
    func editCompanyView() -> some View {
        VStack {
            Text("Ticari Kategori")
                .font(.title3)
                .fontWeight(.semibold)
            
            LazyVGrid(
                    columns: [
                        GridItem(.flexible(minimum: 50, maximum: .infinity)),
                        GridItem(.flexible(minimum: 50, maximum: .infinity))
                    ]
                ) {
                ForEach(CompanyStatus.allCases, id: \.self) { i in
                    let value = cashRoleValue(i)
                    if value != "" {
                        Text(value)
                            .foregroundStyle(.white)
                            .padding(5)
                            .frame(maxWidth: .infinity)
                            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                            .background(viewModel.companyVM.companyDetails.status == i ? Color.accentColor : Color.red, in: .rect(cornerRadius: 30, style: .continuous))
                            .onTapGesture {
                                viewModel.companyVM.companyDetails.status = i
                            }
                            .animation(.bouncy, value: viewModel.companyVM.companyDetails.status)
                    }
                    
                }
            }
        }
        .padding(10)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
    }
}

struct TestDetailView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        CompanyDetail(viewModel: viewModel, company: example_TupleModel.company, companyStatus: .supplier)
    }
}

#Preview {
    TestDetailView()
}
