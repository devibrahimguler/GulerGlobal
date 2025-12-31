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
    
    var body: some View {
        let pendinges = AppState.shared.works.filter({ $0.status == .pending })
        BaseList(isEmpty: pendinges.isEmpty) {
            ForEach(pendinges, id: \.self) { work in
                let company = viewModel.getCompanyById(work.companyId)
                NavigationLink {
                    WorkDetail(
                        firebaseDataService: viewModel.firebaseDataService,
                        work: work,
                        company: company
                    )
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
                            viewModel.workUpdate(
                                workId: work.id,
                                updateArea: ["status": ApprovalStatus.rejected.rawValue]
                            )
                        }
                        
                        Action(tint: .green, icon: "checkmark.square") {
                            withAnimation(.snappy) {
                                viewModel.workUpdate(
                                    workId: work.id,
                                    updateArea: ["status": ApprovalStatus.approved.rawValue]
                                )
                            }
                        }
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
    }
}

#Preview {
    TestBidView()
}
