//
//  SupplierView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 27.10.2024.
//

import SwiftUI

struct SupplierView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isReset: Bool = false
    
    private var list: [Company] {
        viewModel.companyVM.companies.filter { $0.status == .supplier || $0.status == .both}
    }
    
    var body: some View {
        BaseList(isEmpty: list.isEmpty) {
            ForEach(list, id: \.self) { company in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        CompanyDetail(viewModel: viewModel, company: company, companyStatus: .supplier)
                    } label: {
                        SwipeAction(cornerRadius: 30, direction: .trailing, isReset: $isReset) {
                            CompanyCard(company: company)
                        } actions: {
                            Action(tint: .red, icon: "trash.fill") {
                                let statementIds = viewModel.statementVM.statements.filter { $0.companyId == company.id }.map { $0.id }
                                if statementIds.count > 0 {
                                    viewModel.statementVM.multipleDelete(statementIds: statementIds, setLoading: viewModel.setLoading)
                                }
                                
                                let productIds = viewModel.companyProductVM.companyProducts.filter { $0.companyId == company.id }.map { $0.id }
                                if productIds.count > 0 {
                                    viewModel.companyProductVM.multipleDelete(productIds: productIds, setLoading: viewModel.setLoading)
                                }
                                
                                viewModel.companyVM.delete(companyId: company.id, setLoading: viewModel.setLoading)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
        .toolbar {
            NavigationLink {
                CompanyEntry(companyStatus: .supplier)
                    .navigationTitle("Tedarikçi Ekle")
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                Label("Ekle", systemImage: "plus")
            }
            .font(.headline)
            .fontWeight(.semibold)
        }
        .navigationTitle("Tedarikçiler")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
