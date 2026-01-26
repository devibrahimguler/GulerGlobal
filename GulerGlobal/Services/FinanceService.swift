
import Foundation

struct FinanceService {
    
    func calculateNetBalance(
        companies: [Company],
        works: [Work],
        statements: [Statement]
    ) async -> (totalRevenue: Double, leftRevenue: Double, revenueUpdates: [(workId: String, left: Double)]) {
        
        return await Task.detached(priority: .userInitiated) {
            var totalRevenue = 0.0
            var leftRevenue = 0.0
            var updates: [(workId: String, left: Double)] = []
            
            for company in companies {
                var companyTotalMoney = 0.0
                var haveMoney = true
                
                // Calculate statements
                for statement in statements.filter({ $0.companyId == company.id }) {
                    if statement.status == .input || statement.status == .lend {
                        companyTotalMoney += statement.amount
                    } else if statement.status == .output || statement.status == .debt {
                        companyTotalMoney -= statement.amount
                    }
                }
                
                let workList = works.filter { $0.companyId == company.id }.sorted(by: { $0.id < $1.id })
                let finishedWorkList = workList.filter { $0.status == .finished }
                
                // Deduct finished works
                for work in finishedWorkList {
                    companyTotalMoney -= work.cost
                }
                
                // Process all works
                for work in workList {
                    if work.status == .approved {
                        if companyTotalMoney > 0 && haveMoney {
                            companyTotalMoney -= work.cost
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
                        
                        updates.append((workId: work.id, left: left))
                        totalRevenue += work.cost
                        leftRevenue += left
                    }
                }
            }
            
            return (totalRevenue, leftRevenue, updates)
        }.value
    }
}
