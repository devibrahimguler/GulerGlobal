//
//  RejectedView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.03.2024.
//

import SwiftUI

struct RejectedView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isReset: Bool = false
    
    private var list: [Work] {
        viewModel.workVM.works.filter { $0.status == .rejected }
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
                    } label: {
                        SwipeAction(cornerRadius: 30, direction: .trailing, isReset: $isReset) {
                            WorkCard(company: company, work: work)
                        } actions: {
                            Action(tint: .red, icon: "trash.fill") {
                                
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
        .navigationTitle("İptal Projeler")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Test_RejectedView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        RejectedView()
            .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
