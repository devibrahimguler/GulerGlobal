//
//  MainViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 8.09.2024.
//

import SwiftUI
import ContactsUI

@MainActor
final class MainViewModel: ObservableObject {
    let authService: AuthProtocol = UserConnection()
    let firebaseDataService = FirebaseDataModel()
    
    @Published var activeTab: TabValue = .Home
    
    @Published var isLoading: Bool = false
    @Published var isConnected: Bool = false
    
    @Published var companies: [Company] = []
    @Published var works: [Work] = []
    @Published var companyProducts: [CompanyProduct] = []
    @Published var workProducts: [WorkProduct] = []
    @Published var statements: [Statement] = []
    
    @Published var leftRevenue: Double = 0.0 {
        didSet { updateTracking() }
    }
    @Published var totalRevenue: Double = 0.0 {
        didSet { updateTracking() }
    }
    @Published var amountRevenue: Double = 0.0
    @Published var chartData: [ChartData] = []
    @Published var isAnimated: Bool = false
    
    @Published var companyDetails = CompanyDetails()
    @Published var workDetails = WorkDetails()
    @Published var companyProductDetails = CompanyProductDetails()
    @Published var workProductDetails = WorkProductDetails()
    @Published var statementDetails = StatementDetails()
    
    @Published var hasAlert: Bool = false
    @Published var isPhonePicker: Bool = false
    
    init() {
        fetchAllData()
    }
    
    private func updateTracking() {
        self.amountRevenue = self.totalRevenue - self.leftRevenue
        
        self.chartData = [
            ChartData(color: .green.opacity(0.85), value: self.amountRevenue),
            ChartData(color: .red.opacity(0.85), value: self.leftRevenue)
        ]
    }
    
    private func fetchAllData() {
        self.isLoading = true
        
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
                
                self.calculateNetBalance()
                self.isLoading = false
                
                
            }
        }
    }
    
    func getCompanyById(_ companyId: String) -> Company {
        return companies.first(where: { $0.id == companyId }) ?? example_Company
    }
    
    func getCompanyProductById(_ productId: String) -> CompanyProduct {
        return companyProducts.first(where: { $0.id == productId }) ?? example_CompanyProduct
    }
    
    func getWorkProductsById(_ workId: String) -> [WorkProduct] {
        return workProducts.filter { $0.workId == workId }
    }
    
    func generateUniqueIDforWork() -> String {
        let highestID = works.compactMap {  Int($0.id) }.max() ?? 0
        return String(format: "%04d", highestID + 1)
    }
    
    func generateUniqueIDforCompany() -> String {
        let highestID = companies.compactMap {  Int($0.id) }.max() ?? 0
        return String(highestID + 1)
    }
    
    func searchCompanies(by name: String) -> [Company]? {
        guard !name.isEmpty else { return nil }
        return companies.filter { $0.name.lowercased().hasPrefix(name.lowercased()) }
    }
    
    func searchProducts(by name: String) -> [CompanyProduct]? {
        guard !name.isEmpty else { return nil }
        return companyProducts.filter { $0.name.lowercased().hasPrefix(name.lowercased()) }
    }
    
    func updateCompanyDetails(with company: Company?) {
        companyDetails = CompanyDetails(from: company)
    }
    
    func updateWorkDetails(with work: Work?) {
        workDetails = WorkDetails(from: work)
    }
    
    func updateWorkProductDetails(with product: CompanyProduct?) {
        workProductDetails = WorkProductDetails(from: product)
    }
    
    func updateCompanyProductDetails(with product: CompanyProduct?) {
        companyProductDetails = CompanyProductDetails(from: product)
    }
    
    func updateStatementDetails(with statement: Statement?) {
        statementDetails = StatementDetails(from: statement)
    }
    
    func companyCreate(company: Company) {
        isLoading = true
        Task {
            do {
                try await firebaseDataService.companyDataModel.saveCompany(company)
                await MainActor.run {
                    self.companies.append(company)
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func companyUpdate(companyId: String, companyDetails: CompanyDetails) {
        isLoading = true
        Task {
            do {
                guard
                    let index = self.companies.firstIndex(where: { $0.id == companyId }),
                    companyDetails.name != "",
                    companyDetails.address != ""
                else { return }
                
                let name = companyDetails.name.trim()
                let address = companyDetails.address.trim()
                let phone = companyDetails.phone
                let status = companyDetails.status
                
                let updateArea = [
                    "name": name,
                    "address": address,
                    "phone": phone,
                    "status": status.rawValue
                ]
                
                try await firebaseDataService.companyDataModel.updateCompany(companyId, updateArea: updateArea)
                
                
                await MainActor.run {
                    self.companies[index] = Company(
                        id: companyId,
                        name: name,
                        address: address,
                        phone: phone,
                        status: status
                    )
                    updateCompanyDetails(with: nil)
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    updateCompanyDetails(with: nil)
                    self.isLoading = false
                }
            }
        }
    }
    
    func companyDelete(companyId: String) {
        isLoading = true
        Task {
            do {
                try await firebaseDataService.companyDataModel.deleteCompany(companyId)
                
                await MainActor.run {
                    self.companies.removeAll { $0.id == companyId }
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func workCreate(work: Work) {
        isLoading = true
        Task {
            do {
                try await firebaseDataService.workDataModel.saveWork(work)
                
                await MainActor.run {
                    self.works.append(work)
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func workUpdate(workId: String, workDetails: WorkDetails) {
        isLoading = true
        Task {
            do {
                guard
                    let index = self.works.firstIndex(where: { $0.id == workId }),
                    workDetails.name != "",
                    workDetails.description != "",
                    workDetails.cost != "",
                    workDetails.left != ""
                else { return }
                
                let name = workDetails.name.trim()
                let description = workDetails.description.trim()
                let cost = workDetails.cost.toDouble()
                let left = workDetails.left.toDouble()
                let status = workDetails.status
                let startDate = workDetails.startDate
                let endDate = workDetails.endDate
                
                let updateArea = [
                    "name": name,
                    "description": description,
                    "cost": cost,
                    "left": left,
                    "status": status.rawValue,
                    "startDate": startDate,
                    "endDate": endDate,
                ]
                
                try await firebaseDataService.workDataModel.updateWork(workId, updateArea: updateArea)
                
                await MainActor.run {
                    self.works[index] = Work(
                        id: workId,
                        companyId: works[index].companyId,
                        name: name,
                        description: description,
                        cost: cost,
                        left: left,
                        status: status,
                        startDate: startDate,
                        endDate: endDate
                    )
                    updateWorkDetails(with: nil)
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    updateWorkDetails(with: nil)
                    self.isLoading = false
                }
            }
        }
    }
    
    func workDelete(workId: String) {
        isLoading = true
        Task {
            do {
                try await firebaseDataService.workDataModel.deleteWork(workId)
                
                await MainActor.run {
                    self.works.removeAll { $0.id == workId }
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func multipleWorkDelete(workIds: [String]) {
        isLoading = true
        firebaseDataService.workDataModel.deleteMultipleWork(workIds) { (error) in
            if let error = error {
                print("Toplu silme hatası: \(error.localizedDescription)")
                self.isLoading = false
            } else {
                self.works.removeAll { workIds.contains($0.id) }
                self.isLoading = false
            }
        }
    }
    
    func workProductCreate(product: WorkProduct) {
        isLoading = true
        Task {
            do {
                try await firebaseDataService.workProductDataModel.saveWorkProduct(product)
                
                await MainActor.run {
                    self.workProducts.append(product)
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func workProductUpdate(productId: String, workProductDetails: WorkProductDetails) {
        isLoading = true
        Task {
            do {
                guard
                    let index = self.workProducts.firstIndex(where: { $0.productId == productId }),
                    workProductDetails.quantity != ""
                else { return }
                
                let quantity = workProductDetails.quantity.toDouble()
                
                let updateArea = [
                    "quantity": quantity
                ]
                
                try await firebaseDataService.workProductDataModel.updateWorkProduct(productId, updateArea: updateArea)
                
                
                await MainActor.run {
                    self.workProducts[index] = WorkProduct(
                        id: workProducts[index].id,
                        workId: workProducts[index].workId,
                        productId: workProducts[index].productId,
                        quantity: quantity,
                        date: workProducts[index].date
                    )
                    updateWorkProductDetails(with: nil)
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func workProductDelete(productId: String) {
        isLoading = true
        Task {
            do {
                try await firebaseDataService.workProductDataModel.deleteWorkProduct(productId)
                
                await MainActor.run {
                    self.workProducts.removeAll { $0.productId == productId }
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func multipleWorkProductDelete(productIds: [String]) {
        isLoading = true
        firebaseDataService.workProductDataModel.deleteMultipleWorkProduct(productIds) { (error) in
            if let error = error {
                print("Toplu silme hatası: \(error.localizedDescription)")
                self.isLoading = false
            } else {
                self.workProducts.removeAll { productIds.contains($0.id) }
                self.isLoading = false
            }
        }
    }
    
    func companyProductCreate(product: CompanyProduct) {
        isLoading = true
        Task {
            do {
                try await firebaseDataService.companyProductDataModel.saveCompanyProduct(product)
                
                await MainActor.run {
                    self.companyProducts.append(product)
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func companyProductUpdate(productId: String, companyProductDetails: CompanyProductDetails) {
        isLoading = true
        Task {
            do {
                guard
                    let index = self.companyProducts.firstIndex(where: { $0.id == productId }),
                    companyProductDetails.name != "",
                    companyProductDetails.quantity != "",
                    companyProductDetails.price != ""
                else { return }
                
                let name = companyProductDetails.name.trim()
                let quantity = companyProductDetails.quantity.toDouble()
                let price = companyProductDetails.price.toDouble()
                let date = companyProductDetails.date
                let oldPrices = companyProductDetails.oldPrices
                
                let updateArea = [
                    "name": name,
                    "quantity": quantity,
                    "price": price,
                    "date": date,
                    "oldPrices": oldPrices
                ]
                
                try await firebaseDataService.companyProductDataModel.updateCompanyProduct(productId, updateArea: updateArea)
                
                await MainActor.run {
                    self.companyProducts[index] = CompanyProduct(
                        id: productId,
                        companyId: companyProducts[index].companyId,
                        name: name,
                        quantity: quantity,
                        price: price,
                        date: date,
                        oldPrices: oldPrices
                    )
                    updateCompanyProductDetails(with: nil)
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func companyProductDelete(productId: String) {
        isLoading = true
        Task {
            do {
                try await firebaseDataService.companyProductDataModel.deleteCompanyProduct(productId)
                
                await MainActor.run {
                    self.companyProducts.removeAll { $0.id == productId }
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func multipleCompanyProductDelete(productIds: [String]) {
        isLoading = true
        firebaseDataService.companyProductDataModel.deleteMultipleCompanyProduct(productIds) { (error) in
            if let error = error {
                print("Toplu silme hatası: \(error.localizedDescription)")
                self.isLoading = false
            } else {
                self.companyProducts.removeAll { productIds.contains($0.id) }
                self.isLoading = false
            }
        }
    }
    
    func statementCreate(statement: Statement) {
        isLoading = true
        Task {
            do {
                try await firebaseDataService.statementDataModel.saveStatement(statement)
                
                await MainActor.run {
                    self.statements.append(statement)
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func statementUpdate(statementId: String, statementDetails: StatementDetails) {
        isLoading = true
        Task {
            do {
                guard
                    let index = self.statements.firstIndex(where: { $0.id == statementId }),
                    statementDetails.amount != ""
                else { return }
                
   
                let amount = statementDetails.amount.toDouble()
                let date = statementDetails.date
                let status = statementDetails.status
                
                let updateArea = [
                    "amount": amount,
                    "date": date,
                    "status": status.rawValue
                ]
                
                try await firebaseDataService.statementDataModel.updateStatement(statementId, updateArea: updateArea)
                
                await MainActor.run {
                    self.statements[index] = Statement(
                        id: statements[index].id,
                        companyId: statements[index].companyId,
                        amount: amount,
                        date: date,
                        status: status
                    )
                    updateStatementDetails(with: nil)
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func statementDelete(statementId: String) {
        isLoading = true
        Task {
            do {
                try await firebaseDataService.statementDataModel.deleteStatement(statementId)
                
                await MainActor.run {
                    self.statements.removeAll { $0.id == statementId }
                    self.isLoading = false
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func multipleStatementDelete(statementIds: [String]) {
        isLoading = true
        firebaseDataService.statementDataModel.deleteMultipleStatement(statementIds) { (error) in
            if let error = error {
                print("Toplu silme hatası: \(error.localizedDescription)")
                self.isLoading = false
            } else {
                self.statements.removeAll { statementIds.contains($0.id) }
                self.isLoading = false
            }
        }
    }
    
    private func calculateNetBalance() {
        isLoading = true
        for company in self.companies {
            
            var companyTotalMoney = 0.0
            var haveMoney = true
            
            for statement in self.statements.filter({ $0.companyId == company.id }) {
                if statement.status == .input || statement.status == .lend {
                    companyTotalMoney = companyTotalMoney + statement.amount
                } else if statement.status == .output || statement.status == .debt {
                    companyTotalMoney = companyTotalMoney - statement.amount
                }
            }
            
            let workList = self.works.filter { $0.companyId == company.id }.sorted(by: { $0.id < $1.id })
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
                    
                    self.workDetails.name = work.name
                    self.workDetails.description = work.description
                    self.workDetails.cost = "\(work.cost)"
                    self.workDetails.left = "\(left)"
                    self.workDetails.status = work.status
                    self.workDetails.startDate = work.startDate
                    self.workDetails.endDate = work.endDate
                    
                    self.workUpdate(workId: work.id, workDetails: workDetails)
                    self.totalRevenue += work.cost
                    self.leftRevenue += left
                }
            }
            
            
        }
        
        self.updateTracking()
        
        self.isLoading = false
    }
    
    func openPhonePicker() {
        Task { @MainActor in
            let status = CNContactStore.authorizationStatus(for: .contacts)
            if status == .authorized {
                isPhonePicker = true
            }
        }
    }
    
}
