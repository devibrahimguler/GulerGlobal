//
//  TabBarViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim on 14.12.2025.
//

import SwiftUI

@MainActor
final class TabBarViewModel: ObservableObject {
    
    let firebaseDataService = FirebaseDataModel()
    
    @Published var activeTab: TabValue = .Home
    @Published var tabAnimationTrigger: TabValue?
    @Published var searchText = ""
    
    @Published var totalRevenue: Double = 0.0
    @Published var leftRevenue: Double = 0.0
    
    init() {
        fetchAllData()
    }
    private func fetchAllData() {
        AppState.shared.isLoading = true
        
        self.firebaseDataService.fetchAllData { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .failure(let error):
                print("Fetch error: \(error.localizedDescription)")
                AppState.shared.isLoading = false
                
            case .success(let datas):
                AppState.shared.companies = datas.0.sorted(by: { $0.id > $1.id })
                AppState.shared.works = datas.1.sorted(by: { $0.id > $1.id })
                AppState.shared.companyProducts = datas.2.sorted(by: { $0.date > $1.date })
                AppState.shared.workProducts = datas.3.sorted(by: { $0.date > $1.date })
                AppState.shared.statements = datas.4.sorted(by: { $0.date > $1.date })
                
                self.calculateNetBalance()
                AppState.shared.isLoading = false
                
                self.objectWillChange.send()
            }
        }
    }
    
    private func calculateNetBalance() {
        for company in AppState.shared.companies {
            
            var companyTotalMoney = 0.0
            var haveMoney = true
            
            for statement in AppState.shared.statements.filter({ $0.companyId == company.id }) {
                if statement.status == .input || statement.status == .lend {
                    companyTotalMoney = companyTotalMoney + statement.amount
                } else if statement.status == .output || statement.status == .debt {
                    companyTotalMoney = companyTotalMoney - statement.amount
                }
            }
            
            let workList = AppState.shared.works.filter { $0.companyId == company.id }.sorted(by: { $0.id < $1.id })
            let finishedWorkList = workList.filter { $0.status == .finished }
            
            for work in finishedWorkList {
                companyTotalMoney = companyTotalMoney - work.cost
            }
            
            for work in workList {
                
                if work.status == .approved {
                    if companyTotalMoney > 0 && haveMoney {
                        companyTotalMoney = companyTotalMoney - work.cost
                        
                    } else {
                        companyTotalMoney = work.cost
                        haveMoney = false
                    }
                    
                    var left = 0.0
                    if companyTotalMoney < 0 {
                        left = -companyTotalMoney
                    } else {
                        left = companyTotalMoney
                    }
                    
                    self.totalRevenue += work.cost
                    self.leftRevenue += left
                }
            }
            
            
        }
    }
    
}
