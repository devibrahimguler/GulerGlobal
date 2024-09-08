//
//  ApprovedView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 30.01.2024.
//

import SwiftUI

struct ApprovedView: View {
    @EnvironmentObject var dataModel: FirebaseDataModel
    @Binding var selectedCompany: Company?
    @Binding var tab: Tabs
    @Binding var edit: Edit
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataModel.approveWorks, id: \.self) { work in
                    LazyVStack(spacing: 0) {
                        NavigationLink {
                            /*
                             DetailView(company: company)
                                 .environmentObject(dataModel)
                                 .onDisappear {
                                     UITabBar.changeTabBarState(shouldHide: false)
                                 }
                             */
                        } label: {
                            Card(work: work, isApprove: true)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .swipeActions {
                        Button {
                            withAnimation(.snappy) {
                                /*
                                 selectedCompany = company
                                 */
                                tab = .AddBid
                                edit = .Approve
                            }
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                                .contentShape(Rectangle())
                        }
                        .tint(.yellow)
                    }
                    
                }                
            }
            .listStyle(.plain)
            .navigationTitle("Onaylanan Teklifler")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TestApprovedView: View {
    @StateObject private var dataModel: FirebaseDataModel = .init()
    @State private var selectedCompany: Company? = nil
    
    @State private var tab: Tabs = .Approved
    @State private var edit: Edit = .Wait
    
    var body: some View {
        ApprovedView(selectedCompany: $selectedCompany, tab: $tab, edit: $edit)
            .environmentObject(dataModel)
            .tabItem { Image(systemName: "rectangle.stack") }
            .tag(Tabs.Bid)
    }
}

#Preview {
    TestApprovedView()
}
