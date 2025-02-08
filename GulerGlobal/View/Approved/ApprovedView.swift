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
                            .onDisappear {
                                viewModel.isTabBarHidden = false
                            }
                    } label: {
                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                            WorkCard(companyName: company.companyName, work: work, isApprove: true, color: .bRenk)
                        }
                        actions: {
                            Action(tint: .red, icon: "trash.fill") {
                                /*
                                 viewModel.updateWork(.init(
                                     id: work.id,
                                     companyId: work.companyId,
                                     name: work.name,
                                     description: work.description,
                                     price: work.price,
                                     approve: "Unapprove",
                                     accept: work.accept,
                                     products: work.products)
                                 )
                                 */
                            }
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(lineWidth: 1)
                                .fill(Color.iRenk.gradient)
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
