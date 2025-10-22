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
    var company: Company
    var textFieldTitle: FormTitle {
        return status == .input ? .input
        : status == .output ? .output
        : status == .debt ? .debt
        : .lend
    }
    var datePickerTitle: FormTitle {
        return status == .input ? .inputDate
        : status == .output ? .outputDate
        : status == .debt ? .debtDate
        : .lendDate
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            CustomTextField(
                title: textFieldTitle,
                text: $viewModel.statementDetails.amount,
                formTitle: $formTitle, keyboardType: .numberPad
            )
            
            CustomDatePicker(
                dateConfig: $config,
                title: datePickerTitle,
                formTitle: $formTitle
            )
            .foregroundStyle(.isText)

        }
        .navigationTitle(textFieldTitle.rawValue + " Ekle")
        .navigationBarTitleDisplayMode(.inline)
        .padding(10)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(colorScheme == .light ? Color.gray.opacity(0.2) : Color.white.opacity(0.2))
        .animation(.snappy, value: formTitle)
        .onAppear {
            config = dateToConfig(viewModel.statementDetails.date)
        }
        .onDisappear {
            formTitle = .none
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Onayla") {
                    handleStatementSubmission(status: status)
                }
                .foregroundColor(.isGreen)
                .font(.headline)
                .fontWeight(.semibold)
            }
        }
    }
    
    private func handleStatementSubmission(status: StatementStatus) {
        
        guard
            !viewModel.statementDetails.amount.isEmpty
        else { return }
        let statement = Statement(
            amount: viewModel.statementDetails.amount.toDouble(),
            date: configToDate(config),
            status: status
        )
        
        viewModel.createStatement(companyId: company.id, statement: statement)
        viewModel.fetchData()
        
        dismiss()

    }
}

struct Test_StatementEntryView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        StatementEntryView(status: .input, company: example_Company)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_StatementEntryView()
}
