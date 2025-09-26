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
        let list = viewModel.companyList.filter { $0.partnerRole == .supplier || $0.partnerRole == .both}
        BaseList(isEmpty: list.isEmpty) {
            ForEach(list, id: \.self) { company in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        CompanyDetailView(company: company, partnerRole: .supplier)
                            .environmentObject(viewModel)
                    } label: {
                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                            CompanyCard(company: company, color: .isCream)
                        } actions: {
                            Action(tint: .red, icon: "trash.fill") {
                                viewModel.deleteCompany(companyId: company.id)
                            }
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(lineWidth: 1)
                                .fill(Color.isSkyBlue.gradient)
                        }
                    }
                }
            }
        }
        .toolbar {
            NavigationLink {
                CompanyEntryView(partnerRole: .supplier)
            } label: {
                Text("Ekle")
                    .font(.system(size: 14, weight: .black, design: .monospaced))
                    .foregroundStyle(.isGreen)
            }
        }
        .navigationTitle("Tedarikçiler")
    }
}

#Preview {
    ContentView()
}
