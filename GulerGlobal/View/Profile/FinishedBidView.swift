//
//  FinishedBidView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.03.2024.
//

import SwiftUI

struct FinishedBidView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isReset: Bool = false
    
    var body: some View {
        let finishedes = viewModel.works.filter({ $0.status == .finished })
        BaseList(isEmpty: finishedes.isEmpty) {
            ForEach(finishedes, id: \.self) { work in
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
        .navigationTitle("Bitmiş Projeler")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
