//
//  BidView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct BidView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isReset: Bool = false
    @State private var company: Company?
    
    var body: some View {
        BaseList(isEmpty: viewModel.pendingTasks.isEmpty) {
            ForEach(viewModel.pendingTasks, id: \.self) { tuple in
                let company = tuple.company
                let work = tuple.work
                NavigationLink {
                    WorkDetailView(tuple: tuple)
                        .environmentObject(viewModel)
                        .onAppear {
                            isReset.toggle()
                        }
                        .toolbar(.hidden, for: .tabBar)
                } label: {
                    SwipeAction(cornerRadius: 30, direction: .trailing, isReset: $isReset) {
                        WorkCard(company: company, work: work)
                    }
                    actions: {
                        Action(tint: .red, icon: "xmark.bin") {
                            viewModel.updateWork(
                                workId: work.id,
                                updateArea: ["approve": ApprovalStatus.rejected]
                            )
                        }
                        
                        Action(tint: .green, icon: "checkmark.square") {
                            withAnimation(.snappy) {
                                viewModel.updateWork(
                                    workId: work.id,
                                    updateArea: ["approve": ApprovalStatus.approved]
                                )
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    WorkEntryView(company: $company)
                        .environmentObject(viewModel)
                        .navigationTitle("Teklif Ekle")
                        .toolbar(.hidden, for: .tabBar)
                } label: {
                    Text("Ekle")
                        .foregroundStyle(.isGreen)
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                }
            }
        }
    }
}

struct TestBidView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        BidView()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.companyList = [
                    example_TupleModel.company
                ]
                viewModel.allTasks = [
                    example_TupleModel
                ]
                viewModel.pendingTasks = [
                    example_TupleModel
                ]
            }
    }
}

#Preview {
    TestBidView()
}
