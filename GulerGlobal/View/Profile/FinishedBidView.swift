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
        BaseList(isEmpty: viewModel.completedTasks.isEmpty) {
            ForEach(viewModel.completedTasks, id: \.self) { tuple in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        WorkDetailView(tuple: tuple)
                            .environmentObject(viewModel)
                    } label: {
                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                            WorkCard(companyName: tuple.company.companyName, work: tuple.work, isApprove: true, color: .bRenk)
                        } actions: {
                            Action(tint: .red, icon: "trash.fill") {
                                
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
        .navigationTitle("Bitmiş Projeler")
    }
}

#Preview {
    ContentView()
}
