//
//  MainView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.07.2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        TabView(selection: $viewModel.tab) {
            HomeView()
                .environmentObject(viewModel)
                .tabItem { Image(systemName: "house") }
                .tag(Tabs.Home)
            
            BidView()
                .environmentObject(viewModel)
                .tabItem { Image(systemName: "rectangle.stack") }
                .tag(Tabs.Bid)
            
            ApprovedView()
                .environmentObject(viewModel)
                .tabItem { Image(systemName: "checkmark.rectangle.stack.fill") }
                .tag(Tabs.Approved)
            
            ProfileView()
                .environmentObject(viewModel)
                .tabItem { Image(systemName: "person.fill") }
                .tag(Tabs.Profile)
            
        }
        
    }
}

#Preview {
    ContentView()
}
