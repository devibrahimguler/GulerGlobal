//
//  CurrentView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 27.10.2024.
//

import SwiftUI

struct CurrentView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var isReset: Bool = false
    
    private var list: [Company] {
        viewModel.companyVM.companies.filter { $0.status == .current || $0.status == .both }
    }

    var body: some View {
        BaseList(isEmpty: list.isEmpty) {
            ForEach(list) { company in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        CompanyDetail(viewModel: viewModel, company: company, companyStatus: .current)
                    } label: {
                        SwipeAction(cornerRadius: 30, direction: .trailing, isReset: $isReset) {
                            CompanyCard(company: company)
                        } actions: {
                            Action(tint: .red, icon: "trash.fill") {
                                let statementIds = viewModel.statementVM.statements.filter { $0.companyId == company.id }.map { $0.id }
                                if statementIds.count > 0 {
                                    viewModel.statementVM.multipleDelete(statementIds: statementIds, setLoading: viewModel.setLoading)
                                }
                                
                                let workIds = viewModel.workVM.works.filter { $0.companyId == company.id }.map { $0.id }
                                if workIds.count > 0 {
                                    viewModel.workVM.multipleDelete(workIds: workIds, setLoading: viewModel.setLoading)
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
                CompanyEntry(companyStatus: .current)
                    .navigationTitle("Cari Ekle")
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                Label("Ekle", systemImage: "plus")
            }
            .font(.headline)
            .fontWeight(.semibold)
        }
        .navigationTitle("Cariler")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
