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
    
    private var list: [Company] {
        viewModel.companies.filter { $0.status == .debt}
    }
    
    var body: some View {
        BaseList(isEmpty: list.isEmpty) {
            ForEach(list, id: \.self) { company in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        CompanyDetail(viewModel: viewModel, company: company, companyStatus: .supplier)
                    } label: {
                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                            CompanyCard(company: company)
                        } actions: {
                            Action(tint: .red, icon: "trash.fill") {
                                
                            }
                        }
                    }
                    .padding(.horizontal, 10)
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
