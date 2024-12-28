//
//  BidView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct BidView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isAddBid: Bool = false
    
    var body: some View {
        NavigationView {
            BaseList(title: "Teklifler") {
                ForEach(viewModel.waitWorks, id: \.self) { work in
                    let company = viewModel.getCompanyById(work.companyId)
                    
                    LazyVStack(spacing: 0){
                        NavigationLink {
                            
                            WorkDetailView(work: work, isBidView: true)
                                .environmentObject(viewModel)
                                .onDisappear {
                                    UITabBar.changeTabBarState(shouldHide: false)
                                }
                            
                        } label: {
                            Card(companyName: company.name, work: work, isApprove: false)
                        }
                        
                    }
                    .swipeActions {
                        
                        SwipeButton(
                            approveText: "Approve",
                            work: work,
                            buttonStyle: .accept
                        )
                        .environmentObject(viewModel)
                        
                        
                        
                        SwipeButton(
                            approveText: "Unapprove",
                            work: work,
                            buttonStyle: .reject
                        )
                        .environmentObject(viewModel)
                    }
                }
            }
        }
        
    }
    
}

struct TestBidView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        BidView()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.companies = [.init(id: "0", name: "Firma ismi", address: "Fİrma adresi", phone: "(554) 170 16 35", works: ["0000"])]
                viewModel.works = [.init(id: "0000", companyId: "0", name: "iş adı", desc: "iş açıklaması", price: 10000, approve: "Wait", accept: .init(remMoney: 0, recList: [], expList: [], start: .now, finished: .now), products: [])]
                viewModel.waitWorks = [.init(id: "0000", companyId: "0", name: "iş adı", desc: "iş açıklaması", price: 10000, approve: "Wait", accept: .init(remMoney: 0, recList: [], expList: [], start: .now, finished: .now), products: [])]
            }
    }
}

#Preview {
    TestBidView()
}
