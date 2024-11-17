//
//  FinishedBidView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.03.2024.
//

import SwiftUI

struct FinishedBidView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.finishedWorks, id: \.self) { work in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        WorkDetailView(work: work)
                            .environmentObject(viewModel)
                    } label: {
                        Card(work: work, isApprove: true)
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Bitmiş Projeler")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
