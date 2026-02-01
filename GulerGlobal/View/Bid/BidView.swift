//
//  BidView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct BidView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isReset: Bool = false
    
    private var list: [Work] {
        viewModel.works.filter { $0.status == .pending }
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
                                withAnimation(.snappy) {
                                    viewModel.workDetails.name = work.name
                                    viewModel.workDetails.description = work.description
                                    viewModel.workDetails.cost = "\(work.cost)"
                                    viewModel.workDetails.left = "\(work.left)"
                                    viewModel.workDetails.status = .rejected
                                    viewModel.workDetails.startDate = work.startDate
                                    viewModel.workDetails.endDate = work.endDate
                                    
                                    
                                    viewModel.workUpdate(
                                        workId: work.id,
                                        workDetails: viewModel.workDetails
                                    )
                                }
                            }
                            
                            Action(tint: .green, icon: "checkmark.square") {
                                withAnimation(.snappy) {
                                    viewModel.workDetails.name = work.name
                                    viewModel.workDetails.description = work.description
                                    viewModel.workDetails.cost = "\(work.cost)"
                                    viewModel.workDetails.left = "\(work.left)"
                                    viewModel.workDetails.status = .approved
                                    viewModel.workDetails.startDate = work.startDate
                                    viewModel.workDetails.endDate = work.endDate
                                    
                                    viewModel.workUpdate(
                                        workId: work.id,
                                        workDetails: viewModel.workDetails
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
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
    }
}

#Preview {
    TestBidView()
}
