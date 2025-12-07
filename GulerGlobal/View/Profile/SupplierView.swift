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
    
    var body: some View {
        let list = viewModel.companies.filter { $0.status == .supplier || $0.status == .both}
        BaseList(isEmpty: list.isEmpty) {
            ForEach(list, id: \.self) { company in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        CompanyDetail(company: company, companyStatus: .supplier)
                            .environmentObject(viewModel)
                    } label: {
                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                            CompanyCard(company: company)
                        } actions: {
                            Action(tint: .red, icon: "trash.fill") {
                                let statementIds = viewModel.statements.filter { $0.companyId == company.id }.map { $0.id }
                                if statementIds.count > 0 {
                                    viewModel.multipleStatementDelete(statementIds: statementIds)
                                }
                                
                                let productIds = viewModel.companyProducts.filter { $0.companyId == company.id }.map { $0.id }
                                if productIds.count > 0 {
                                    viewModel.multipleCompanyProductDelete(productIds: productIds)
                                }
                                
                                viewModel.companyDelete(companyId: company.id)
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            NavigationLink {
                CompanyEntry(companyStatus: .supplier)
                    .navigationTitle("Tedarikçi Ekle")
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                Text("Ekle")
                    .font(.system(size: 14, weight: .black, design: .monospaced))
                    .foregroundStyle(.green)
            }
        }
        .navigationTitle("Tedarikçiler")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
