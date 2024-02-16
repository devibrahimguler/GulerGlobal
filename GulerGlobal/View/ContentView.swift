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
    @State private var detailCompany: Company? = nil
    
    var body: some View {
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            
            TabView(selection: $tab) {
                /*
                 HomeView()
                 .environmentObject(companyViewModel)
                 .tabItem {
                 Image(systemName: "house")
                 }
                 .tag(Tabs.Home)
                 */
                
                BidView(selectedCompany: $selectedCompany, tab: $tab, edit: $edit, detailCompany: $detailCompany)
                    .environmentObject(companyViewModel)
                    .tabItem {
                        Image(systemName: "rectangle.stack")
                    }
                    .tag(Tabs.Bid)
                
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
                
                ApprovedView(selectedCompany: $selectedCompany, tab: $tab, edit: $edit, detailCompany: $detailCompany, topEdge: topEdge)
                    .environmentObject(companyViewModel)
                    .tabItem {
                        if #available(iOS 17.0, *) {
                            Image(systemName: "checkmark.rectangle.stack.fill")
                        } else {
                            Image(systemName: "checkmark.rectangle.fill")
                        }
                        
                    }
                    .tag(Tabs.Approved)
                
                /*
                 ProfileView()
                 .environmentObject(companyViewModel)
                 .tabItem {
                 Image(systemName: "person.fill")
                 }
                 .tag(Tabs.Profile)
                 */
            }
            .offset(x: tab == .AddBid  ? -1000 : 0)
            .animation(.snappy, value: tab)
            .overlay {
                AddBidView(tab: $tab, edit: $edit, company: $selectedCompany)
                    .environmentObject(companyViewModel)
                    .offset(x: tab == .AddBid ? 0 : 1000)
                    .animation(.snappy, value: tab)
            }
            .sheet(item: $detailCompany) { company in
                DetailView(company: company)
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
