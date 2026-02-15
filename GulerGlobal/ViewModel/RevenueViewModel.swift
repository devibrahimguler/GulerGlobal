//
//  RevenueViewModel.swift
//  GulerGlobal
//
//  Refactored from MainViewModel — SRP: Revenue calculation & chart data only.
//

import SwiftUI

@MainActor
final class RevenueViewModel: ObservableObject {
    @Published var leftRevenue: Double = 0.0 {
        didSet { updateTracking() }
    }
    @Published var totalRevenue: Double = 0.0 {
        didSet { updateTracking() }
    }
    @Published var amountRevenue: Double = 0.0
    @Published var chartData: [ChartData] = []
    @Published var isAnimated: Bool = false
    
    // MARK: - Tracking
    
    func updateTracking() {
        self.amountRevenue = self.totalRevenue - self.leftRevenue
        
        self.chartData = [
            ChartData(color: .green.opacity(0.85), value: self.amountRevenue),
            ChartData(color: .red.opacity(0.85), value: self.leftRevenue)
        ]
    }
    
    // MARK: - Net Balance Calculation
    
    func calculateNetBalance(companies: [Company],
                             works: [Work],
                             statements: [Statement],
                             workVM: WorkViewModel,
                             setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        
        for company in companies {
            
            var companyTotalMoney = 0.0
            var haveMoney = true
            
            for statement in statements.filter({ $0.companyId == company.id }) {
                if statement.status == .input || statement.status == .lend {
                    companyTotalMoney = companyTotalMoney + statement.amount
                } else if statement.status == .output || statement.status == .debt {
                    companyTotalMoney = companyTotalMoney - statement.amount
                }
            }
            
            let workList = works.filter { $0.companyId == company.id }.sorted(by: { $0.id < $1.id })
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
                    
                    workVM.workDetails.name = work.name
                    workVM.workDetails.description = work.description
                    workVM.workDetails.cost = "\(work.cost)"
                    workVM.workDetails.left = "\(left)"
                    workVM.workDetails.status = work.status
                    workVM.workDetails.startDate = work.startDate
                    workVM.workDetails.endDate = work.endDate
                    
                    workVM.update(workId: work.id, workDetails: workVM.workDetails, setLoading: { _ in })
                    self.totalRevenue += work.cost
                    self.leftRevenue += left
                }
            }
        }
        
        self.updateTracking()
        setLoading(false)
    }
}
