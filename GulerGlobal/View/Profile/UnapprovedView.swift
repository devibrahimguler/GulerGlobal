//
//  UnapprovedView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.03.2024.
//

import SwiftUI

struct UnapprovedView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.unapproveWorks, id: \.self) { work in
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
        .navigationTitle("İptal Projeler")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
