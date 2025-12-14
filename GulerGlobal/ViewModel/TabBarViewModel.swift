//
//  TabBarViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim on 14.12.2025.
//

import Foundation

@MainActor
final class TabBarViewModel: ObservableObject {
    
    private let firebaseDataService = FirebaseDataModel()
    @Published var isLoading: Bool = false
    
    @Published var activeTab: TabValue = .Home
    @Published var tabAnimationTrigger: TabValue?
    @Published var searchText = ""
    
    @Published var companies: [Company] = []
    @Published var works: [Work] = []
    @Published var companyProducts: [CompanyProduct] = []
    @Published var workProducts: [WorkProduct] = []
    @Published var statements: [Statement] = []
    
    private func fetchAllData() {
        resetAllData()
        
        self.firebaseDataService.fetchAllData { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .failure(let error):
                print("Fetch error: \(error.localizedDescription)")
                self.isLoading = false
                
            case .success(let datas):
                self.companies = datas.0.sorted(by: { $0.id > $1.id })
                self.works = datas.1.sorted(by: { $0.id > $1.id })
                self.companyProducts = datas.2.sorted(by: { $0.date > $1.date })
                self.workProducts = datas.3.sorted(by: { $0.date > $1.date })
                self.statements = datas.4.sorted(by: { $0.date > $1.date })
                
                self.isLoading = false
                
                
            }
        }
    }
    
    private func resetAllData() {
        companies.removeAll()
        works.removeAll()
        companyProducts.removeAll()
        workProducts.removeAll()
        statements.removeAll()
    }
    
}
