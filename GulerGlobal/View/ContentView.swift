//
//  ContentView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var companyViewModel: CompanyViewModel = .init()
    @State private var selectionTab: SelectionTab = .Bid
    @State private var edit: EditSection = .AddBid
    
    @State private var isAccepts: Bool = false
    @State private var selectedCompany: Company? = nil
    
    var body: some View {
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            
            TabView(selection: $selectionTab) {
                HomeView()
                    .environmentObject(companyViewModel)
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(SelectionTab.Home)
                
                BidView(selectedCompany: $selectedCompany, selectionTab: $selectionTab, edit: $edit, topEdge: topEdge)
                    .environmentObject(companyViewModel)
                    .tabItem {
                        Image(systemName: "rectangle.stack")
                    }
                    .tag(SelectionTab.Bid)
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
                    .tag(SelectionTab.AddBid)
                
                ApprovedView(selectedCompany: $selectedCompany, selectionTab: $selectionTab, edit: $edit, topEdge: topEdge)
                    .environmentObject(companyViewModel)
                    .tabItem {
                        Image(systemName: "checkmark.rectangle.stack")
                    }
                    .tag(SelectionTab.Approved)
                    .ignoresSafeArea(.all, edges: .top)
                
                ProfileView()
                    .environmentObject(companyViewModel)
                    .tabItem {
                        Image(systemName: "person.fill")
                    }
                    .tag(SelectionTab.Profile)
            }
            .offset(x: selectionTab == .AddBid  ? -700 : 0)
            .animation(.snappy, value: selectionTab)
            .overlay {
                AddBidView(selectionTab: $selectionTab, edit: $edit, company: $selectedCompany, topEdge: topEdge)
                    .environmentObject(companyViewModel)
                    .offset(x: selectionTab == .AddBid ? 0 : 700)
                    .animation(.snappy, value: selectionTab)
                    .ignoresSafeArea(.all, edges: .top)
            }
        }
        
    }
}

#Preview {
    ContentView()
}

enum SelectionTab {
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
