//
//  MainViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 8.09.2024.
//  Refactored: Thin coordinator composing domain-specific sub-ViewModels (SOLID/SRP).
//

import SwiftUI
import ContactsUI

@MainActor
final class MainViewModel: ObservableObject {
    let authService: AuthProtocol
    let firebaseDataService: FirebaseDataModel
    
    // MARK: - Sub-ViewModels
    @Published var companyVM: CompanyViewModel
    @Published var workVM: WorkViewModel
    @Published var companyProductVM: CompanyProductViewModel
    @Published var workProductVM: WorkProductViewModel
    @Published var statementVM: StatementViewModel
    @Published var revenueVM = RevenueViewModel()
    
    // MARK: - Shared UI State
    @Published var activeTab: TabValue = .Home
    @Published var isLoading: Bool = false
    @Published var isConnected: Bool = false
    @Published var hasAlert: Bool = false
    @Published var isPhonePicker: Bool = false
    
    // MARK: - Init
    
    init(authService: AuthProtocol = UserConnection(),
         firebaseDataService: FirebaseDataModel = FirebaseDataModel()) {
        self.authService = authService
        self.firebaseDataService = firebaseDataService
        
        self.companyVM = CompanyViewModel(dataModel: firebaseDataService.companyDataModel)
        self.workVM = WorkViewModel(dataModel: firebaseDataService.workDataModel)
        self.companyProductVM = CompanyProductViewModel(dataModel: firebaseDataService.companyProductDataModel)
        self.workProductVM = WorkProductViewModel(
            dataModel: firebaseDataService.workProductDataModel,
            companyProductDataModel: firebaseDataService.companyProductDataModel
        )
        self.statementVM = StatementViewModel(dataModel: firebaseDataService.statementDataModel)
        
        fetchAllData()
    }
    
    // MARK: - Data Loading
    
    private func fetchAllData() {
        self.isLoading = true
        
        self.firebaseDataService.fetchAllData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print("Fetch error: \(error.localizedDescription)")
                self.isLoading = false
                
            case .success(let datas):
                self.companyVM.companies = datas.0.sorted(by: { $0.id > $1.id })
                self.workVM.works = datas.1.sorted(by: { $0.id > $1.id })
                self.companyProductVM.companyProducts = datas.2.sorted(by: { $0.date > $1.date })
                self.workProductVM.workProducts = datas.3.sorted(by: { $0.date > $1.date })
                self.statementVM.statements = datas.4.sorted(by: { $0.date > $1.date })
                
                self.revenueVM.calculateNetBalance(
                    companies: self.companyVM.companies,
                    works: self.workVM.works,
                    statements: self.statementVM.statements,
                    workVM: self.workVM,
                    setLoading: { [weak self] loading in
                        self?.isLoading = loading
                    }
                )
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Contact Picker
    
    func openPhonePicker() {
        Task { @MainActor in
            let status = CNContactStore.authorizationStatus(for: .contacts)
            if status == .authorized {
                isPhonePicker = true
            }
        }
    }
    
    // MARK: - Loading Helper
    
    func setLoading(_ loading: Bool) {
        self.isLoading = loading
    }
}
