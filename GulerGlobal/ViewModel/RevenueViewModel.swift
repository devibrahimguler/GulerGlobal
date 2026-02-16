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
            let companyStatements = statements.filter { $0.companyId == company.id }
            let companyWorks = works.filter { $0.companyId == company.id }.sorted { $0.id < $1.id }
            
            // Net balance from statements (input/lend add, output/debt subtract)
            var balance = companyStatements.reduce(0.0) { result, s in
                switch s.status {
                case .input, .lend:  return result + s.amount
                case .output, .debt: return result - s.amount
                }
            }
            
            // Subtract finished work costs
            balance -= companyWorks.filter { $0.status == .finished }.reduce(0.0) { $0 + $1.cost }
            
            // Process approved works
            for work in companyWorks where work.status == .approved {
                balance -= work.cost
                let left = -(balance)
                
                var details = WorkDetails(from: work)
                details.left = "\(left)"
                workVM.update(workId: work.id, workDetails: details, setLoading: { _ in })
                
                self.totalRevenue += work.cost
                self.leftRevenue += left
            }
        }
        
        self.updateTracking()
        setLoading(false)
    }
}
