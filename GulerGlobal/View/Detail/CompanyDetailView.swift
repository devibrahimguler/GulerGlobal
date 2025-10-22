//
//  DetailView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 14.02.2024.
//

import SwiftUI

struct CompanyDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: MainViewModel
    
    @State private var isEditCompany: Bool = false
    @State private var formTitle: FormTitle = .none
    
    @State private var addType: ListType = .none
    @State private var isReset: Bool = false
    @State private var openMenu: Bool = false
    @State private var hiddingAnimation: Bool = false
    
    var company: Company
    var partnerRole: PartnerRole
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                
                VStack(spacing: 0) {
                    CustomTextField(title: .companyName, text: $viewModel.companyDetails.name, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                    
                    CustomTextField(title: .companyAddress, text: $viewModel.companyDetails.address, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                    
                    CustomTextField(title: .companyPhone, text: $viewModel.companyDetails.contactNumber, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                    
                    
                }
                .scaleEffect(x: isEditCompany ? 0.97 : 1, y: isEditCompany ? 0.97 : 1)
                .animation(isEditCompany ? .easeInOut(duration: 0.5).repeatForever() : .easeInOut(duration: 0.5), value: isEditCompany)
                .padding(10)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                if isEditCompany {
                    VStack {
                        Text("Ticari Kategoriler")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        HStack {
                            ForEach(PartnerRole.allCases, id: \.self) { i in
                                let value = cashRoleValue(i)
                                if value != "" {
                                    Text(value)
                                        .foregroundStyle(.isText)
                                        .padding(5)
                                        .frame(maxWidth: .infinity)
                                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                                        .background(viewModel.companyDetails.partnerRole == i ? Color.blue.opacity(0.5) : Color.red.opacity(0.5), in: .rect(cornerRadius: 30, style: .continuous))
                                        .onTapGesture {
                                            viewModel.companyDetails.partnerRole = i
                                        }
                                        .animation(.bouncy, value: viewModel.companyDetails.partnerRole)
                                    
                                    
                                }
                                
                            }
                        }
                    }
                    .padding(10)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                }
                
                VStack(spacing: 10) {
                    let workList = company.workList.sorted { $0.id > $1.id }
                    let productList = viewModel.allProducts.filter { $0.supplier == company.companyName }
                    let statementList = viewModel.statementTasks.first(where: { $0.companyId == company.id })?.statement.sorted { $0.date > $1.date }
                    
                    if company.workList.count > 1 {
                        WorkListView(
                            title: "İş Listesi",
                            list: workList,
                            company: company,
                            hiddingAnimation: $hiddingAnimation
                        )
                        .environmentObject(viewModel)
                    }
                    
                    if let statementList = statementList {
                        if !statementList.isEmpty {
                            StatementListView (
                                title: "Finans Kayıtları",
                                list: statementList,
                                company: company,
                                hiddingAnimation: $hiddingAnimation
                            )
                            .environmentObject(viewModel)
                        }
                    }
                    
                    if !productList.isEmpty {
                        ProductListView(
                            title: "Malzeme Listesi",
                            list: productList,
                            company: company,
                            isSupplier: true,
                            hiddingAnimation: $hiddingAnimation
                        )
                        .environmentObject(viewModel)
                    }
                    
                }
                .opacity(isEditCompany ? 0 : 1)
                
            }
            .padding(.horizontal, 10)
            
        }
        .navigationTitle("Guler Global")
        .navigationBarTitleDisplayMode(.inline)
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2))
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
            .offset(y: openMenu ? 0 : 500)
            
        }
        .navigationBarBackButtonHidden(openMenu || isEditCompany)
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
            viewModel.updateCompanyDetails(with: company)
        }
        .onDisappear {
            viewModel.updateCompanyDetails(with: nil)
        }
        
    }
    
    func cashRoleValue(_ value: PartnerRole) -> String {
        switch value {
        case .none:
            return ""
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
}

struct TestDetailView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        CompanyDetailView(company: example_TupleModel.company, partnerRole: .supplier)
            .environmentObject(viewModel)
    }
}

#Preview {
    TestDetailView()
}

struct CompanyMenu: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Binding var isEdit: Bool
    @Binding var formTitle: FormTitle
    @Binding var openMenu: Bool
    
    var company: Company
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Button {
                withAnimation(.spring) {
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
                        viewModel.saveUpdates(company: company)
                        
                        formTitle = .none
                        openMenu = false
                        isEdit.toggle()
                    }
                } label: {
                    Label("Kaydet", systemImage: "pencil.line")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 20)
            } else {
                if company.partnerRole == .supplier || company.partnerRole == .both {
                    NavigationLink {
                        ProductEntryView(company: company, workId: nil, isSupplier: true)
                            .environmentObject(viewModel)
                    } label: {
                        Label("Malzeme Ekle", systemImage: "plus.viewfinder")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                    .padding(.horizontal, 20)
                }
                NavigationLink {
                    StatementEntryView(status: .input, company: company)
                        .environmentObject(viewModel)
                } label: {
                    Label("Alınan Para", systemImage: "square.badge.plus")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 20)
                
                NavigationLink {
                    StatementEntryView(status: .output, company: company)
                        .environmentObject(viewModel)
                } label: {
                    Label("Ödenen Para", systemImage: "bag.badge.plus")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 20)
                
                NavigationLink {
                    StatementEntryView(status: .debt, company: company)
                        .environmentObject(viewModel)
                } label: {
                    Label("Alınan Borç", systemImage: "bag.badge.plus")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 20)
                
                NavigationLink {
                    StatementEntryView(status: .lend, company: company)
                        .environmentObject(viewModel)
                } label: {
                    Label("Verilen Borç", systemImage: "bag.badge.plus")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 20)
            }
        }
    }
}
