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
        let companyIds = viewModel.statementVM.statements
            .filter {
                $0.status == .debt
            }.map { $0.companyId }
        
        return viewModel.companyVM.companies.filter { company in
            companyIds.contains(company.id)
        }
    }
    
    var body: some View {
        BaseList(isEmpty: list.isEmpty) {
            ForEach(list, id: \.self) { company in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        CompanyDetail(viewModel: viewModel, company: company, companyStatus: .debt)
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
        .navigationTitle("Borçlar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DebtView()
}
