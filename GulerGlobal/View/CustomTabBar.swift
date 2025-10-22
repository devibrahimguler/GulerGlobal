//
//  CustomTabBar.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.07.2024.
//

import SwiftUI

struct CustomTabBar: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var searchText = ""
    
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
                    let list = viewModel.companyList.filter { $0.companyName.hasPrefix(searchText)}
                    BaseList(isEmpty: list.isEmpty) {
                        ForEach(list, id: \.self) { company in
                            LazyVStack(spacing: 0) {
                                NavigationLink {
                                    CompanyDetailView(company: company, partnerRole: .supplier)
                                        .environmentObject(viewModel)
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    CompanyCard(company: company)
                                }
                            }
                        }
                    }
                    .navigationTitle("Firma Ara")
                    .searchable(text: $searchText, placement: .toolbar, prompt: Text("Ara..."))
                }
            }
            
        }
        .tabViewSearchActivation(.searchTabSelection)
        .environmentObject(viewModel)
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

#Preview {
    ContentView()
}

enum TabValue: String, CaseIterable {
    case Home = "GulerMetSan"
    case Bid = "Teklifler"
    case Approved = "İşler"
    case Profile = "Kullanıcı"
    case Search = "Ara"
    
    var symbolImage: String {
        switch self {
        case .Home: "house"
        case .Bid: "rectangle.stack"
        case .Approved: "checkmark.rectangle.stack.fill"
        case .Profile: "person.fill"
        case .Search: "magnifyingglass"
        }
    }
}
