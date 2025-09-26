//
//  StatementListView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 18.01.2025.
//

import SwiftUI

struct StatementListView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isHidden: Bool = true
    @State private var isReset: Bool = true
    
    var title: String
    var status: StatementStatus
    var list: [Statement]
    var tuple: TupleModel
    @Binding var hiddingAnimation: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 20) {
                
                NavigationLink {
                    StatementEntryView(status: status, tuple: tuple)
                        .environmentObject(viewModel)
                } label: {
                    Image(systemName: "plus.viewfinder")
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.init(degrees: isHidden ? 180 : 0))
                    .onTapGesture {
                        isHidden.toggle()
                        hiddingAnimation.toggle()
                    }
            }
            .padding()
            .background(.background, in: .rect(cornerRadius: 20))
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(list, id: \.self) { statement in
                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                            StatementCard(statement: statement)
                        }
                        actions: {
                            Action(tint: .red, icon: "trash.fill", iconFont: .title3) {
                                withAnimation(.snappy) {
                                    if statement.status == .received {
                                        let remainingBalance: Double = viewModel.remMoneySnapping(price: tuple.work.totalCost, statements: tuple.work.statements) + statement.amount
                                        
                                        let workUpdateArea = [
                                            "remainingBalance": remainingBalance
                                        ]
                                        
                                        viewModel.updateWork(companyId: tuple.company.id, workId: tuple.work.id, updateArea: workUpdateArea)
                                    }
                                    
                                    viewModel.deleteStatement(companyId: tuple.company.id, workId: tuple.work.id, statementId: statement.id)
                                }
                            }
                            
                            Action(tint: .isGreen, icon: "checkmark.square", iconFont: .title3, isEnabled: !(status == .received)) {
                                withAnimation(.snappy) {
                                    let remainingBalance: Double = viewModel.remMoneySnapping(price: tuple.work.totalCost, statements: tuple.work.statements) - statement.amount
                                    
                                    let workUpdateArea = [
                                        "remainingBalance": remainingBalance
                                    ]
                                    
                                    let statementUpdateArea = [
                                        "status": "Received"
                                    ]
                                    
                                    viewModel.updateWork(companyId: tuple.company.id, workId: tuple.work.id, updateArea: workUpdateArea)
                                    viewModel.updateStatement(companyId: tuple.company.id, workId: tuple.work.id, statementId: statement.id, updateArea: statementUpdateArea)
                                }
                            }
                        }
                        .padding(5)
                    }
                }
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(height: isHidden ? 0 : 400)
        }
        .animation(.linear, value: isHidden)
    }
}

struct Test_StatementListView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @State private var hiddingAnimation: Bool = false
    
    var body: some View {
        VStack {
            StatementListView(
                title: "Alınan Paralar",
                status: .received,
                list: example_StatementList,
                tuple: example_TupleModel,
                hiddingAnimation: $hiddingAnimation
            )
        }
        .environmentObject(viewModel)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
    }
}

#Preview {
    Test_StatementListView()
}

struct StatementCard: View {
    
    var statement: Statement
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            
            Label {
                Text("\(statement.amount.customDouble())")
            } icon: {
                Image(systemName: "turkishlirasign")
            }
            .font(.title3)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Label {
                Text("\(statement.date.getStringDate(.long))")
            } icon: {
                Image(systemName: "calendar")
            }
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(.gray)
            
        }
        .padding()
        .background(statement.status == .debs ? Color.red : Color.isCream)
        .frame(maxWidth: .infinity)
    }
}
