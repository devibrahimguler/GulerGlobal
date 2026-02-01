//
//  CustomTabBar.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.07.2024.
//

import SwiftUI

struct CustomTabBar: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        TabView(selection: $viewModel.activeTab) {
            Tab(TabValue.Home.rawValue, systemImage: TabValue.Home.symbolImage, value: TabValue.Home) {
                HomeView()
            }
            
            Tab(TabValue.Bid.rawValue, systemImage: TabValue.Bid.symbolImage, value: TabValue.Bid) {
                NavigationStack {
                    BidView()
                        .navigationTitle(TabValue.Bid.rawValue)
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
                    ProfileView(viewModel: viewModel)
                }
            }
            
            Tab(TabValue.Search.rawValue, systemImage: TabValue.Search.symbolImage, value: TabValue.Search, role: .search) {
                NavigationStack {
                    SearchView()
                        .environmentObject(viewModel)
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
