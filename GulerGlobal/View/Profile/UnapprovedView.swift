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
        BaseList(title: "İptal Projeler") {
            ForEach(viewModel.unapproveWorks, id: \.self) { work in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        WorkDetailView(work: work)
                            .environmentObject(viewModel)
                    } label: {
                        Card(work: work, isApprove: true)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
