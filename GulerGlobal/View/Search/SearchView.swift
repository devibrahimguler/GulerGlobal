//
//  SearchView.swift
//  GulerGlobal
//
//  Created by ibrahim on 30.01.2026.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State var searchText = ""
    
    var body: some View {
        let list = viewModel.companies.filter { $0.name.hasPrefix(searchText)}
        BaseList(isEmpty: list.isEmpty) {
            ForEach(list, id: \.self) { company in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        CompanyDetail(company: company, companyStatus: .supplier)
                            .toolbar(.hidden, for: .tabBar)
                    } label: {
                        SwipeAction(cornerRadius: 30, direction: .trailing, isReset: Binding.constant(false)) {
                            CompanyCard(company: company)
                        } actions: {
                            
                        }
                    }
                }
            }
        }
        .navigationTitle("Firma Ara")
        .searchable(text: $searchText, placement: .toolbar, prompt: Text("Ara..."))
    }
}

#Preview {
    SearchView()
}
