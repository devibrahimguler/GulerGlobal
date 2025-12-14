//
//  CustomTabBar.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.07.2024.
//

import SwiftUI

struct CustomTabBar: View {
    @StateObject private var viewModel = TabBarViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.activeTab) {
            Tab(TabValue.Home.rawValue, systemImage: TabValue.Home.symbolImage, value: TabValue.Home) {
                HomeView()
            }
           
            Tab(TabValue.Bid.rawValue, systemImage: TabValue.Bid.symbolImage, value: TabValue.Bid) {
                NavigationStack {
                    BidView()
                        .navigationTitle(TabValue.Bid.rawValue)
                        .navigationBarTitleDisplayMode(.inline )
                }
            }
            
            Tab(TabValue.Approved.rawValue, systemImage: TabValue.Approved.symbolImage, value: TabValue.Approved) {
                NavigationStack {
                    ApprovedView()
                        .navigationTitle(TabValue.Bid.rawValue)
                }
            }
            
            Tab(TabValue.Profile.rawValue, systemImage: TabValue.Profile.symbolImage, value: TabValue.Profile) {
                NavigationStack {
                    ProfileView()
                }
            }
            
            Tab(TabValue.Search.rawValue, systemImage: TabValue.Search.symbolImage, value: TabValue.Search, role: .search) {
                NavigationStack {
                    let list = viewModel.companies.filter { $0.name.hasPrefix(viewModel.searchText)}
                    BaseList(isEmpty: list.isEmpty) {
                        ForEach(list, id: \.self) { company in
                            LazyVStack(spacing: 0) {
                                NavigationLink {
                                    CompanyDetail(company: company, companyStatus: .supplier)
                                        .environmentObject(viewModel)
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    CompanyCard(company: company)
                                }
                            }
                        }
                    }
                    .navigationTitle("Firma Ara")
                    .searchable(text: $viewModel.searchText, placement: .toolbar, prompt: Text("Ara..."))
                }
            }
            
        }
        .tabViewSearchActivation(.searchTabSelection)
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

#Preview {
    ContentView()
}
