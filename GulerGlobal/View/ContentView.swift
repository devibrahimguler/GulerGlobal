//
//  ContentView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var companyViewModel: CompanyViewModel = .init()
    @State private var selectionTab: Tag = .Bid
    @State private var isAccepts: Bool = false
    @State private var selectedCompany: Company? = nil
    
    var body: some View {
        TabView(selection: $selectionTab) {
            HomeView()
                .environmentObject(companyViewModel)
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(Tag.Home)
            
            BidView(selectedCompany: $selectedCompany, selectionTab: $selectionTab)
                .environmentObject(companyViewModel)
                .tabItem {
                    Image(systemName: "checklist.unchecked")
                }
                .tag(Tag.Bid)
            
           Spacer()
                .tabItem {
                    Image(systemName: "plus")
                }
                .tag(Tag.AddBid)
                
            
            UnapprovedView()
                .environmentObject(companyViewModel)
                .tabItem {
                    Image(systemName: "checklist.checked")
                }
                .tag(Tag.Unapproved)
            
            ProfileView()
                .environmentObject(companyViewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(Tag.Profile)
        }
        .offset(x: selectionTab == .AddBid ? -700 : 0)
        .animation(.snappy, value: selectionTab)
        .overlay {
            AddBidView(selectionTab: $selectionTab, company: $selectedCompany)
                .environmentObject(companyViewModel)
                .offset(x: selectionTab == .AddBid ? 0 : 700)
                .animation(.snappy, value: selectionTab)
        }
    }
}

#Preview {
    ContentView()
}

enum Tag {
    case Home
    case Bid
    case AddBid
    case Unapproved
    case Profile
}
