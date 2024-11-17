//
//  CompaniesView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 29.09.2024.
//

import SwiftUI

struct CompaniesView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.companies, id: \.self) { company in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                         CompanyDetailView(company: company)
                            .environmentObject(viewModel)
                    } label: {
                        CompanyCard(company: company)
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Firmalar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
