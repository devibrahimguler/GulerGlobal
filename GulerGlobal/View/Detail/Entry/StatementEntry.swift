//
//  StatementEntryView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.02.2025.
//

import SwiftUI

struct StatementEntry: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var viewModel: MainViewModel
    @State private var formTitle: FormTitle = .none
    @State private var isClicked: Bool = false
    
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
                text: $viewModel.statementVM.statementDetails.amount,
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
        .padding(.vertical)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .animation(.snappy, value: formTitle)
        .onAppear {
            config = viewModel.statementVM.statementDetails.date.dateToConfig()
        }
        .onDisappear {
            formTitle = .none
        }
        .toolbar {
            CustomItem(title: "Onayla", icon: "checkmark", isClicked: isClicked) {
                submission()
            }
        }
    }
    
    private func submission() {
        isClicked = true
        
        guard
            !viewModel.statementVM.statementDetails.amount.isEmpty
        else {
            isClicked = false
            return
        }
        let statement = Statement(
            companyId: company.id,
            amount: viewModel.statementVM.statementDetails.amount.toDouble(),
            date: config.configToDate(),
            status: status
        )
        
        viewModel.statementVM.create(statement: statement, setLoading: viewModel.setLoading)
        
        isClicked = false
        dismiss()

    }
}

struct Test_StatementEntry: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        StatementEntry(status: .input, company: example_Company)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_StatementEntry()
}
