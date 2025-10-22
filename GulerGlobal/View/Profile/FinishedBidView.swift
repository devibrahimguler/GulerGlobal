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
                        SwipeAction(cornerRadius: 30, direction: .trailing, isReset: $isReset) {
                            WorkCard(company: tuple.company, work: tuple.work)
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
