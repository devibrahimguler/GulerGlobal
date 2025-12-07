//
//  DebtView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 9.10.2025.
//

import SwiftUI

struct DebtView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isReset: Bool = false
    
    var body: some View {
        let list = viewModel.companies.filter { $0.status == .debt}
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
                                
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            NavigationLink {
                CompanyEntry(companyStatus: .debt)
                    .navigationTitle("Borç Ekle")
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                Text("Ekle")
                    .font(.system(size: 14, weight: .black, design: .monospaced))
                    .foregroundStyle(.green)
            }
        }
        .navigationTitle("Borçlar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DebtView()
}
