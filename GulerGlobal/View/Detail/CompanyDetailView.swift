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
                .background(.background, in: .rect(cornerRadius: 20))
                
                if isEditCompany {
                    VStack {
                        Text("Ticari Kategoriler")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        HStack {
                            ForEach(PartnerRole.allCases, id: \.self) { i in
                                let value = cashRoleValue(i)
                                if value != "" {
                                    VStack(spacing: 10) {
                                        Text(value)
                                    }
                                    .foregroundStyle(viewModel.companyDetails.partnerRole == i ? .white : .isCream)
                                    .padding(5)
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.companyDetails.partnerRole == i ? .accent : .isSkyBlue)
                                    .onTapGesture {
                                        viewModel.companyDetails.partnerRole = i
                                    }
                                    .animation(.bouncy, value: viewModel.companyDetails.partnerRole)
                                    
                                }
                                
                            }
                        }
                    }
                    .padding(10)
                    .background(.background, in: .rect(cornerRadius: 20))
                }
                
                VStack(spacing: 10) {
                    let productList = viewModel.allProducts.filter { $0.supplier == company.companyName }
                    let statementList = viewModel.statementTasks.first(where: { $0.companyId == company.id })?.statement
                    
                    Text("Durum Raporu")
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(.background, in: .rect(cornerRadius: 20))
                        .opacity(company.workList.isEmpty ? productList.isEmpty ? 0 : 1 : 1)
                    
                    if partnerRole == .current {
                        if !company.workList.isEmpty {
                            VStack(spacing: 5) {
                                ForEach(company.workList, id: \.self) { work in
                                    if work.id != "0000" {
                                        
                                        let approved = work.approve == .approved ? true : false
                                        
                                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                                            WorkCard(companyName: company.companyName , work: work, isApprove: approved)
                                        } actions: {
                                            Action(tint: .isRed, icon: "trash.fill") {
                                                withAnimation(.snappy) {
                                                    viewModel.deleteWork(companyId: company.id, workId: work.id)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(10)
                            .background(.background)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    else if partnerRole == .supplier {
                        
                        if !productList.isEmpty {
                            VStack(spacing: 5) {
                                ForEach(productList, id: \.self) { product in
                                    SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                                        ProductCard(product: product)
                                    } actions: {
                                        
                                    }
                                    
                                }
                            }
                            .padding(10)
                            .background(.background)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        
                        if let statementList = statementList {
                            if !statementList.isEmpty {
                                VStack(spacing: 5) {
                                    ForEach(statementList, id: \.self) { statement in
                                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                                            StatementCard(statement: statement)
                                        } actions: {
                                            Action(tint: .isRed, icon: "trash.fill") {
                                                withAnimation(.snappy) {
                                                    viewModel.deleteStatement(companyId: company.id, workId: "0000", statementId: statement.id)
                                                    viewModel.fetchData()
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                                .padding(10)
                                .background(.background)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                    }
                    
                }
                .opacity(isEditCompany ? 0 : 1)
                
            }
            .navigationTitle("Guler Global")
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding(.horizontal, 10)
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2))
        .blur(radius: openMenu ? 5 : 0)
        .disabled(openMenu)
        .overlay(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    withAnimation(.spring) {
                        formTitle = .none
                        openMenu = false
                        isEditCompany.toggle()
                    }
                } label: {
                    if isEditCompany {
                        Label("İptal", systemImage: "pencil.slash")
                    } else {
                        Label("Düzenle", systemImage: "square.and.pencil")
                    }
                }
                
                if isEditCompany {
                    Button {
                        withAnimation(.spring) {
                            if viewModel.companyDetails.name != company.companyName {
                                if viewModel.companyList.first(where: { $0.companyName == viewModel.companyDetails.name }) != nil {
                                    return
                                }
                            }
                            
                            let companyName = viewModel.companyDetails.name.trim()
                            let companyAddress = viewModel.companyDetails.address.trim()
                            let contactNumber = viewModel.companyDetails.contactNumber
                            let partnerRoleRawValue = viewModel.companyDetails.partnerRole.rawValue
                            
                            let updateArea = [
                                "companyName": companyName,
                                "companyAddress": companyAddress,
                                "contactNumber": contactNumber,
                                "partnerRole": partnerRoleRawValue
                            ]
                            
                            viewModel.updateCompany(companyId: company.id, updateArea: updateArea)
                            
                            formTitle = .none
                            openMenu = false
                            isEditCompany.toggle()
                        }
                    } label: {
                        Label("Kaydet", systemImage: "pencil.line")
                    }
                } else {
                    if partnerRole == .supplier {
                        let tuple = TupleModel(company: company, work: example_Work)
                        
                        NavigationLink {
                            StatementEntryView(status: .debs, tuple: tuple)
                                .environmentObject(viewModel)
                                .onAppear {
                                    openMenu = false
                                }
                        } label: {
                            Label("Borç Ekle", systemImage: "square.badge.plus")
                        }
                        
                        NavigationLink {
                            StatementEntryView(status: .hookup, tuple: tuple)
                                .environmentObject(viewModel)
                                .onAppear {
                                    openMenu = false
                                }
                        } label: {
                            Label("Bağlantı Ekle", systemImage: "bag.badge.plus")
                        }
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
