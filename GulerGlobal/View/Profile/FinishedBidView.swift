//
//  FinishedBidView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.03.2024.
//

import SwiftUI

struct FinishedBidView: View {
    @EnvironmentObject var dataModel: FirebaseDataModel
    @Binding var tab: Tabs
    @Binding var edit: Edit
    
    var body: some View {
        List {
            ForEach(dataModel.finishedWorks, id: \.self) { work in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        /*
                         DetailView(company: company)
                             .environmentObject(dataModel)
                         */
                    } label: {
                        Card(work: work, isApprove: true)
                    }
                }
                .listRowSeparator(.hidden)
                .swipeActions {
                }
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
