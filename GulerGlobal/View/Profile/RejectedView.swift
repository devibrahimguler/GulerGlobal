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
    var body: some View {
        let rejectedes = viewModel.works.filter({ $0.status == .rejected })
        BaseList(isEmpty: rejectedes.isEmpty) {
            ForEach(rejectedes, id: \.self) { work in
                let company = viewModel.getCompanyById(work.companyId)
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        WorkDetail(work: work, company: company)
                            .environmentObject(viewModel)
                    } label: {
                        SwipeAction(cornerRadius: 30, direction: .trailing, isReset: $isReset) {
                            WorkCard(company: company, work: work)
                        } actions: {
                            Action(tint: .red, icon: "trash.fill") {
                                
                            }
                        }
                    }
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
