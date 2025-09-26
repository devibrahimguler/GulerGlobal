//
//  StatementEntryView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.02.2025.
//

import SwiftUI

struct StatementEntryView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var viewModel: MainViewModel
    @State private var formTitle: FormTitle = .none
    @State private var config: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    
    var status: StatementStatus
    var tuple: TupleModel
    
    var body: some View {
        VStack(spacing: 8) {
            
            CustomTextField(
                title: status == .received ? .recMoney : .expMoney,
                text: $viewModel.workDetails.statementAmount,
                formTitle: $formTitle, keyboardType: .numberPad
            )
            
            CustomDatePicker(
                dateConfig: $config,
                title: status == .received ? .recDate : .expDate,
                activeTitle: $formTitle
            )
            
            Button("Onayla") {
                handleStatementSubmission(status: status)
            }
            .foregroundColor(.isText)
            .font(.headline)
            .fontWeight(.semibold)
            .padding(10)
            .background(.isGreen, in: .rect(cornerRadius: 10))
            
        }
        .padding(10)
        .background(.background, in: .rect(cornerRadius: 20))
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(colorScheme == .light ? Color.gray.opacity(0.2) : Color.white.opacity(0.2))
        .animation(.snappy, value: formTitle)
        .onAppear {
            config = dateToConfig(viewModel.workDetails.statementDate)
        }
        .onDisappear {
            formTitle = .none
        }
    }
    
    private func handleStatementSubmission(status: StatementStatus) {
        
        guard
            !viewModel.workDetails.statementAmount.isEmpty
        else { return }
        let statement = Statement(
            amount: viewModel.workDetails.statementAmount.toDouble(),
            date: configToDate(config),
            status: status
        )
        
        if status == .hookup || status == .debs {
            viewModel.createStatement(companyId: tuple.company.id, workId: tuple.work.id, statement: statement)
            viewModel.fetchData()
        } else {
            if status == .received {
                let remainingBalance: Double = viewModel.remMoneySnapping(price: tuple.work.totalCost, statements: tuple.work.statements) - statement.amount
                
                let workUpdateArea = [
                    "remainingBalance": remainingBalance
                ]
                viewModel.updateWork(companyId: tuple.company.id, workId: tuple.work.id, updateArea: workUpdateArea)
            }
            
            viewModel.createStatement(companyId: tuple.company.id, workId: tuple.work.id, statement: statement)

        }
        
        dismiss()

    }
}

struct Test_StatementEntryView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        StatementEntryView(status: .received, tuple: example_TupleModel)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_StatementEntryView()
}
