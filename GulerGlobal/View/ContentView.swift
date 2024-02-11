//
//  ContentView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var companyViewModel: CompanyViewModel = .init()
    @State private var tab: Tabs = .Bid
    @State private var edit: EditSection = .AddBid
    
    @State private var isAccepts: Bool = false
    @State private var selectedCompany: Company? = nil
    
    var body: some View {
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            
            TabView(selection: $tab) {
                HomeView()
                    .environmentObject(companyViewModel)
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(Tabs.Home)
                
                BidView(selectedCompany: $selectedCompany, tab: $tab, edit: $edit, topEdge: topEdge)
                    .environmentObject(companyViewModel)
                    .tabItem {
                        Image(systemName: "rectangle.stack")
                    }
                    .tag(Tabs.Bid)
                    .ignoresSafeArea(.all, edges: .top)
                
               Spacer()
                    .tabItem {
                        Button {
                            withAnimation(.snappy) {
                                edit = .AddBid
                            }
                        } label: {
                            Image(systemName: "plus.app.fill")
                        }

             
                    }
                    .tag(Tabs.AddBid)
                
                ApprovedView(selectedCompany: $selectedCompany, tab: $tab, edit: $edit, topEdge: topEdge)
                    .environmentObject(companyViewModel)
                    .tabItem {
                        Image(systemName: "checkmark.rectangle.stack")
                    }
                    .tag(Tabs.Approved)
                    .ignoresSafeArea(.all, edges: .top)
                
                ProfileView()
                    .environmentObject(companyViewModel)
                    .tabItem {
                        Image(systemName: "person.fill")
                    }
                    .tag(Tabs.Profile)
            }
            .offset(x: tab == .AddBid  ? -700 : 0)
            .animation(.snappy, value: tab)
            .overlay {
                AddBidView(tab: $tab, edit: $edit, company: $selectedCompany, topEdge: topEdge)
                    .environmentObject(companyViewModel)
                    .offset(x: tab == .AddBid ? 0 : 700)
                    .animation(.snappy, value: tab)
                    .ignoresSafeArea(.all, edges: .top)
            }
        }
        
    }
}

#Preview {
    ContentView()
}

enum Tabs {
    case Home
    case Bid
    case AddBid
    case Approved
    case Profile
}

enum EditSection {
    case Bid
    case AddBid
    case EditBid
    case ApproveBid
}
