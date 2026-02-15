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
        viewModel.workVM.works.filter { $0.status == .pending }
    }
    
    var body: some View {
        BaseList(isEmpty: list.isEmpty) {
            ForEach(list) { work in
                let company = viewModel.companyVM.getById(work.companyId)
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
                                    viewModel.workVM.workDetails.name = work.name
                                    viewModel.workVM.workDetails.description = work.description
                                    viewModel.workVM.workDetails.cost = "\(work.cost)"
                                    viewModel.workVM.workDetails.left = "\(work.left)"
                                    viewModel.workVM.workDetails.status = .rejected
                                    viewModel.workVM.workDetails.startDate = work.startDate
                                    viewModel.workVM.workDetails.endDate = work.endDate
                                    
                                    
                                    viewModel.workVM.update(
                                        workId: work.id,
                                        workDetails: viewModel.workVM.workDetails,
                                        setLoading: viewModel.setLoading
                                    )
                                }
                            }
                            
                            Action(tint: .green, icon: "checkmark.square") {
                                withAnimation(.snappy) {
                                    viewModel.workVM.workDetails.name = work.name
                                    viewModel.workVM.workDetails.description = work.description
                                    viewModel.workVM.workDetails.cost = "\(work.cost)"
                                    viewModel.workVM.workDetails.left = "\(work.left)"
                                    viewModel.workVM.workDetails.status = .approved
                                    viewModel.workVM.workDetails.startDate = work.startDate
                                    viewModel.workVM.workDetails.endDate = work.endDate
                                    
                                    viewModel.workVM.update(
                                        workId: work.id,
                                        workDetails: viewModel.workVM.workDetails,
                                        setLoading: viewModel.setLoading
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
