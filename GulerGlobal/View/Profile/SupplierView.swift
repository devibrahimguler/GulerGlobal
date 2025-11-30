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
        let list = viewModel.companyList.filter { $0.status == .supplier || $0.status == .both}
        BaseList(isEmpty: list.isEmpty) {
            ForEach(list, id: \.self) { company in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        CompanyDetailView(company: company, companyStatus: .supplier)
                            .environmentObject(viewModel)
                    } label: {
                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                            CompanyCard(company: company)
                        } actions: {
                            Action(tint: .red, icon: "trash.fill") {
                                viewModel.deleteCompany(companyId: company.id)
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            NavigationLink {
                CompanyEntryView(companyStatus: .supplier)
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
