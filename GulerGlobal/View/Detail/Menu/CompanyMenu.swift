//
//  CompanyMenu.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 28.10.2025.
//

import SwiftUI

extension CompanyEntry {
    struct CompanyMenu: View {
        @Binding var viewModel: ViewModel
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
                            viewModel.companyUpdate(company: company)
                            
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
                            ProductEntry(
                                dataService: viewModel.dataService,
                                fetch: viewModel.fetch,
                                isLoading: viewModel.isLoading,
                                allProducts: viewModel.allProducts,
                                company: company,
                                workId: nil,
                                isSupplier: true,
                                companyList: viewModel.companyList
                            )
                        } label: {
                            Label("Malzeme Ekle", systemImage: "plus.viewfinder")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                        .padding(.horizontal, 20)
                    } else if company.partnerRole == .current || company.partnerRole == .both {
                        NavigationLink {
                            WorkEntry(fetch: viewModel.fetch, dataService: viewModel.dataService, isLoading: viewModel.isLoading, allTasks: viewModel.workVM.allTasks, company: company)
                                .navigationTitle("Teklif Ekle")
                                .toolbar(.hidden, for: .tabBar)
                        } label: {
                            Text("Ekle")
                                .foregroundStyle(.isGreen)
                                .font(.system(size: 14, weight: .black, design: .monospaced))
                        }
                    }
                    NavigationLink {
                        StatementEntry(status: .input, company: company)
                            //.environmentObject(viewModel)
                    } label: {
                        Label("Alınan Para", systemImage: "square.badge.plus")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                    .padding(.horizontal, 20)
                    
                    NavigationLink {
                        StatementEntry(status: .output, company: company)
                            // .environmentObject(viewModel)
                    } label: {
                        Label("Ödenen Para", systemImage: "bag.badge.plus")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                    .padding(.horizontal, 20)
                    
                    NavigationLink {
                        StatementEntry(status: .debt, company: company)
                            // .environmentObject(viewModel)
                    } label: {
                        Label("Alınan Borç", systemImage: "bag.badge.plus")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                    .padding(.horizontal, 20)
                    
                    NavigationLink {
                        StatementEntry(status: .lend, company: company)
                            // .environmentObject(viewModel)
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
}

