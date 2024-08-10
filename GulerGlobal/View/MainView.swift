//
//  MainView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.07.2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var dataModel: FirebaseDataModel
    @State private var selectedCompany: Company? = nil
    
    @State private var tab: Tabs = .Home
    @State private var edit: Edit = .Wait
    
    @State private var isAccepts: Bool = false
    @State private var isDetail: Bool = false
    
    var body: some View {
        TabView(selection: $tab) {
            HomeView()
                .environmentObject(dataModel)
                .tabItem { Image(systemName: "house") }
                .tag(Tabs.Home)
            
            BidView(selectedCompany: $selectedCompany, tab: $tab, edit: $edit)
                .environmentObject(dataModel)
                .tabItem { Image(systemName: "rectangle.stack") }
                .tag(Tabs.Bid)
            
            AddBidView(tab: $tab, edit: $edit, company: $selectedCompany)
                .environmentObject(dataModel)
                .tabItem { Image(systemName: "plus.app.fill") }
                .tag(Tabs.AddBid)
               
            
            ApprovedView(selectedCompany: $selectedCompany, tab: $tab, edit: $edit)
                .environmentObject(dataModel)
                .tabItem {
                    if #available(iOS 17.0, *) { Image(systemName: "checkmark.rectangle.stack.fill") }
                    else { Image(systemName: "checkmark.rectangle.fill") }
                }
                .tag(Tabs.Approved)
            
            ProfileView(selectedCompany: $selectedCompany, tab: $tab, edit: $edit)
                .environmentObject(dataModel)
                .tabItem { Image(systemName: "person.fill") }
                .tag(Tabs.Profile)
            
        }.onChange(of: tab) { tab in
            if tab == .AddBid {
                UITabBar.changeTabBarState(shouldHide: true)
            }
        }
        
    }
}

#Preview {
    ContentView()
}
