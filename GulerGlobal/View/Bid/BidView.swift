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
        ZStack(alignment: .topTrailing) {
            HStack {
                
                Text("Teklifler")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                NavigationLink {
                    WorkEntryView(company: $company)
                        .environmentObject(viewModel)
                } label: {
                    Text("Ekle")
                        .foregroundStyle(.isGreen)
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                }
                .padding(.trailing)
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(.ultraThinMaterial)
            .zIndex(1)
            
            BaseList(isEmpty: viewModel.pendingTasks.isEmpty, padding: 50) {
                ForEach(viewModel.pendingTasks, id: \.self) { tuple in
                    let company = tuple.company
                    let work = tuple.work
                    NavigationLink {
                        WorkDetailView(tuple: tuple, isBidView: true)
                            .environmentObject(viewModel)
                            .onAppear {
                                isReset.toggle()
                            }
                    } label: {
                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                            WorkCard(companyName: company.companyName, work: work, isApprove: false)
                        }
                        actions: {
                            Action(tint: .red, icon: "xmark.bin") {
                                viewModel.updateWork(
                                    companyId: company.id,
                                    workId: work.id,
                                    updateArea: ["approve": ApprovalStatus.rejected.rawValue,]
                                )
                            }
                            
                            Action(tint: .green, icon: "checkmark.square") {
                                withAnimation(.snappy) {
                                    viewModel.updateWork(
                                        companyId: company.id,
                                        workId: work.id,
                                        updateArea: ["approve": ApprovalStatus.approved.rawValue]
                                    )
                                }
                            }
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(lineWidth: 1)
                                .fill(Color.isSkyBlue.gradient)
                        }
                    }
                }
            }
            .zIndex(0)

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
