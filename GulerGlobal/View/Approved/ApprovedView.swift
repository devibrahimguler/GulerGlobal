//
//  ApprovedView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 30.01.2024.
//

import SwiftUI

struct ApprovedView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = MainViewModel()
    @State private var isReset: Bool = false
    
    var body: some View {
        let approvedes = viewModel.works.filter({ $0.status == .approved })
        BaseList(isEmpty: approvedes.isEmpty) {
            ForEach(approvedes, id: \.self) { work in
                let company = viewModel.getCompanyById(work.companyId)
                LazyVStack(spacing: 0) {
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
