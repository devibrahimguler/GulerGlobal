//
//  ApprovedView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 30.01.2024.
//

import SwiftUI

struct ApprovedView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isReset: Bool = false
    
    private var list: [Work] {
        viewModel.works.filter { $0.status == .approved }
    }
    
    var body: some View {
        BaseList(isEmpty: list.isEmpty) {
            ForEach(list) { work in
                let company = viewModel.getCompanyById(work.companyId)
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        WorkDetail(
                            work: work,
                            company: company
                        )
                        .environmentObject(viewModel)
                        .onAppear {
                            isReset.toggle()
                        }
                        .toolbar(.hidden, for: .tabBar)
                    } label: {
                        SwipeAction(cornerRadius: 30, direction: .trailing, isReset: $isReset) {
                            WorkCard(company: company, work: work)
                        }
                        actions: {
                            Action(tint: .red, icon: "xmark.bin") {
                                viewModel.workDetails.status = .rejected
                                viewModel.workUpdate(
                                    workId: work.id,
                                    workDetails: viewModel.workDetails
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
    }
}

struct Test_ApprovedView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        ApprovedView()
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_ApprovedView()
}
