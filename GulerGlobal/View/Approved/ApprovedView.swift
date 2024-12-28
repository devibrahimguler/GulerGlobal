//
//  ApprovedView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 30.01.2024.
//

import SwiftUI

struct ApprovedView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        NavigationView {
            BaseList(title: "Onaylanan Teklifler") {
                ForEach(viewModel.approveWorks, id: \.self) { work in
                    let company = viewModel.getCompanyById(work.companyId)
                    LazyVStack(spacing: 0) {
                        NavigationLink {
                            WorkDetailView(work: work)
                                .environmentObject(viewModel)
                                .onDisappear {
                                    UITabBar.changeTabBarState(shouldHide: false)
                                }
                        } label: {
                            Card(companyName: company.name, work: work, isApprove: true)
                        }
                    }
                }
            }
        }
    }
}

struct TestApprovedView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        ApprovedView()
            .environmentObject(viewModel)
    }
}

#Preview {
    TestApprovedView()
}
