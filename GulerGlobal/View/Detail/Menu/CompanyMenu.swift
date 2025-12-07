//
//  CompanyMenu.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 28.10.2025.
//

import SwiftUI

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
                        
                        guard
                            viewModel.companyDetails.name != "",
                            viewModel.companyDetails.address != ""
                        else { return }
                        
                        let updateArea = [
                            "name": viewModel.companyDetails.name,
                            "address": viewModel.companyDetails.address,
                            "phone": viewModel.companyDetails.phone,
                            "status": viewModel.companyDetails.status.rawValue
                        ]
                        
                        viewModel.companyUpdate(companyId: company.id, updateArea: updateArea)
                        
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
                        CompanyProductEntry(company: company)
                            .environmentObject(viewModel)
                    } label: {
                        Label("Malzeme Ekle", systemImage: "plus.viewfinder")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                    .padding(.horizontal, 20)
                } else if company.status == .current || company.status == .both {
                    NavigationLink {
                        WorkEntry(company: company)
                            .environmentObject(viewModel)
                    } label: {
                        Label("İş Ekle", systemImage: "rectangle.stack.fill.badge.plus")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                    .padding(.horizontal, 20)
                }
                NavigationLink {
                    StatementEntry(status: .input, company: company)
                        .environmentObject(viewModel)
                } label: {
                    Label("Alınan Para", systemImage: "square.badge.plus")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 20)
                
                NavigationLink {
                    StatementEntry(status: .output, company: company)
                        .environmentObject(viewModel)
                } label: {
                    Label("Ödenen Para", systemImage: "bag.badge.plus")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 20)
                
                NavigationLink {
                    StatementEntry(status: .debt, company: company)
                        .environmentObject(viewModel)
                } label: {
                    Label("Alınan Borç", systemImage: "bag.badge.plus")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 20)
                
                NavigationLink {
                    StatementEntry(status: .lend, company: company)
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

