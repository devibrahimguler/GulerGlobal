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
    @EnvironmentObject var viewModel: MainViewModel
    
    @State private var isEditCompany: Bool = false
    @State private var formTitle: FormTitle = .none
    
    @State private var addType: ListType = .none
    @State private var isReset: Bool = false
    @State private var openMenu: Bool = false
    @State private var hiddingAnimation: Bool = false
    
    var company: Company
    var companyStatus: CompanyStatus
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                
                VStack(spacing: 0) {
                    CustomTextField(title: .companyName, text: $viewModel.companyDetails.name, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                    
                    CustomTextField(title: .companyAddress, text: $viewModel.companyDetails.address, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                    
                    CustomTextField(title: .companyPhone, text: $viewModel.companyDetails.phone, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                    
                }
                .scaleEffect(x: isEditCompany ? 0.97 : 1, y: isEditCompany ? 0.97 : 1)
                .animation(isEditCompany ? .easeInOut(duration: 0.5).repeatForever() : .easeInOut(duration: 0.5), value: isEditCompany)
                .padding(10)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                if isEditCompany {
                    editCompanyView()
                }
                
                 VStack(spacing: 10) {
                     let works = viewModel.works.filter { $0.companyId == company.id }.sorted { $0.id > $1.id }
                     let products = viewModel.companyProducts.filter { $0.companyId == company.id }.sorted { $0.date > $1.date }
                     let statements = viewModel.statements.filter { $0.companyId == company.id }.sorted { $0.date > $1.date }
                     
                     if !works.isEmpty {
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
                     
                     if !products.isEmpty {
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
            .padding(.horizontal, 10)
            
        }
        .navigationTitle(company.name)
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
            Text("Ticari Kategoriler")
                .font(.title3)
                .fontWeight(.semibold)
            
            HStack {
                ForEach(CompanyStatus.allCases, id: \.self) { i in
                    let value = cashRoleValue(i)
                    if value != "" {
                        Text(value)
                            .foregroundStyle(.white)
                            .padding(5)
                            .frame(maxWidth: .infinity)
                            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                            .background(viewModel.companyDetails.status == i ? Color.blue.opacity(0.5) : Color.red.opacity(0.5), in: .rect(cornerRadius: 30, style: .continuous))
                            .onTapGesture {
                                viewModel.companyDetails.status = i
                            }
                            .animation(.bouncy, value: viewModel.companyDetails.status)
                        
                        
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
        CompanyDetail(company: example_TupleModel.company, companyStatus: .supplier)
            .environmentObject(viewModel)
    }
}

#Preview {
    TestDetailView()
}

/*
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
                 if company.status == .supplier || company.status == .both {
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
 */
