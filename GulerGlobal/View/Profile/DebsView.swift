//
//  DebsView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 27.10.2024.
//

import SwiftUI

struct DebsView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isAddDeb: Bool = false
    
    var body: some View {
        BaseList(title: "Borçlar") {
            ForEach(viewModel.companies, id: \.self) { company in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        CompanyDetailView(company: company)
                            .environmentObject(viewModel)
                    } label: {
                        CompanyCard(company: company)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
