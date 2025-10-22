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
    @State private var isReset: Bool = false
    
    var body: some View {
        BaseList(isEmpty: viewModel.approvedTasks.isEmpty) {
            ForEach(viewModel.approvedTasks, id: \.self) { tuple in
                let company = tuple.company
                let work = tuple.work
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        WorkDetailView(tuple: tuple)
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
                                viewModel.updateWork(
                                    companyId: company.id,
                                    workId: work.id,
                                    updateArea: ["approve": ApprovalStatus.rejected.rawValue,]
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
