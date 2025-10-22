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
        BaseList(isEmpty: viewModel.rejectedTasks.isEmpty) {
            ForEach(viewModel.rejectedTasks, id: \.self) { tuple in
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
