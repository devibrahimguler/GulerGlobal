//
//  WorkEntry.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI


struct WorkEntry: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @State private var activeField: FormTitle = .none
    @State private var hiddingAnimation: Bool = false
    
    @State private var startConfig: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    @State private var endConfig: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    
    @State private var viewModel: ViewModel
    
    init(
        fetch: @escaping () -> Void,
        dataService: FirebaseDataModel,
        isLoading: Bool,
        allTasks: [TupleModel],
        company: Company
    ) {
        _viewModel = State(wrappedValue: ViewModel(
            fetch: fetch,
            dataService: dataService,
            isLoading: isLoading,
            allTasks: allTasks,
            company: company
        ))
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                CustomTextField(
                    title: .projeNumber,
                    text: $viewModel.workDetails.id,
                    formTitle: $activeField,
                    keyboardType: .numberPad,
                    color: viewModel.workDetails.isChangeProjeNumber ? .black : .gray
                )
                .disabled(!viewModel.workDetails.isChangeProjeNumber)
                .onTapGesture {
                    withAnimation(.snappy) {
                        viewModel.workDetails.isChangeProjeNumber.toggle()
                    }
                }
                
                CustomTextField(title: .workName, text: $viewModel.workDetails.name, formTitle: $activeField)
                
                CustomTextField(title: .workDescription, text: $viewModel.workDetails.description, formTitle: $activeField)
                
                CustomTextField(title: .workPrice, text: $viewModel.workDetails.totalCost, formTitle: $activeField, keyboardType: .numberPad)
                
                CustomDatePicker(dateConfig: $startConfig, title: .startDate, formTitle: $activeField)
                    .foregroundStyle(.isText)
                
                CustomDatePicker(dateConfig: $endConfig, title: .finishDate, formTitle: $activeField)
                    .foregroundStyle(.isText)
            }
            .padding(10)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20, style: .continuous))
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle(viewModel.company.name)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.linear, value: hiddingAnimation)
        .background(colorScheme == .light ? Color.gray.opacity(0.2) : Color.white.opacity(0.2))
        .onAppear {
            viewModel.workDetails.id = viewModel.generateUniqueID()
            startConfig = dateToConfig(viewModel.workDetails.startDate)
            endConfig = dateToConfig(viewModel.workDetails.endDate)
        }
        .animation(.snappy, value: activeField)
        .onDisappear {
            activeField = .none
            viewModel.updateWorkDetails(with: nil)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Onayla") {
                    handleWorkSubmission()
                }
                .foregroundStyle(.isGreen)
                .font(.headline)
                .fontWeight(.semibold)
            }
        }
        
    }
    
    private func handleWorkSubmission() {
        guard
              !viewModel.workDetails.id.isEmpty,
              !viewModel.workDetails.name.isEmpty,
              !viewModel.workDetails.description.isEmpty,
              !viewModel.workDetails.totalCost.isEmpty else { return }
        
        viewModel.workDetails.approve = .pending
        
        let newWork = Work(
            id: viewModel.workDetails.id,
            workName: viewModel.workDetails.name,
            workDescription: viewModel.workDetails.description,
            remainingBalance: viewModel.workDetails.totalCost.toDouble(),
            totalCost: viewModel.workDetails.totalCost.toDouble(),
            approve: viewModel.workDetails.approve,
            productList: viewModel.workDetails.productList,
            startDate: configToDate(startConfig),
            endDate: configToDate(endConfig)
        )
        
        viewModel.workCreate(companyId: viewModel.company.id, work: newWork)
        dismiss()
    }
}


struct Test_WorkEntryView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    var body: some View {
        WorkEntry(fetch: viewModel.fetch, dataService: viewModel.dataService, isLoading: viewModel.isLoading, allTasks: viewModel.allTasks, company: example_Company)
    }
}

#Preview {
    Test_WorkEntryView()
        .preferredColorScheme(.dark)
}

extension WorkEntry {
    @Observable
    class ViewModel {
        let dataService: FirebaseDataModel
        let fetch: () -> Void
        var workDetails = WorkDetails()
        var isLoading: Bool = false
        let allTasks: [TupleModel]
        let company: Company
        
        init(fetch: @escaping () -> Void, dataService:FirebaseDataModel, isLoading: Bool, allTasks: [TupleModel], company: Company) {
            self.fetch = fetch
            self.dataService = dataService
            self.isLoading = isLoading
            self.allTasks = allTasks
            self.company = company
        }
        
        func generateUniqueID() -> String {
            let highestID = allTasks.compactMap {  Int($0.work.id) }.max() ?? 0
            return String(format: "%04d", highestID + 1)
        }
        
        func updateWorkDetails(with work: Work?) {
            workDetails = WorkDetails(from: work)
        }
        
        func workCreate(companyId: String, work: Work) {
            isLoading = true
            dataService.companyDataModel.workDataModel.create(companyId, work)
            fetch()
        }
    }
}
