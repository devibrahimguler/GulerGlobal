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
    // MARK: - Dependencies
    let authService: AuthProtocol = UserConnection()
    private let firebaseDataService = FirebaseDataModel()
    
    // MARK: - Published Properties
    @Published var activeTab: TabValue = .Home
    
    @Published var isLoadingPlaceholder: Bool = false
    @Published var isUserConnected: Bool = false
    
    @Published var companies: [Company] = []
    @Published var works: [Work] = []
    @Published var companyProducts: [CompanyProduct] = []
    @Published var workProducts: [WorkProduct] = []
    @Published var statements: [Statement] = []
    
    
    @Published var totalRevenue: Double = 0
    @Published var leftRevenue: Double = 0
    
    @Published var companyDetails = CompanyDetails()
    @Published var workDetails = WorkDetails()
    @Published var companyProductDetails = CompanyProductDetails()
    @Published var workProductDetails = WorkProductDetails()
    @Published var statementDetails = StatementDetails()
    
    @Published var traking: [Tracking] = []
    @Published var isAnimated: Bool = false
    @Published var hasAlert: Bool = false
    
    @Published var isPhonePicker: Bool = false
    
    @Published var acceptRem: String = ""
    
    // MARK: - Initializer
    
    init() {
        connectionControl()
        fetchAllData()
    }
    
    // MARK: - Public Methods
    func connectionControl() {
        isUserConnected = authService.getUid != nil
    }
    
    func fetchData() {
        isLoadingPlaceholder = true
        
        let group = DispatchGroup()
        
        group.enter()
        fetchCompanyData {
            group.leave()
        }
        
        group.enter()
        fetchWorkData {
            group.leave()
        }
        
        group.enter()
        fetchCompanyProductData {
            group.leave()
        }
        
        group.enter()
        fetchWorkProductData {
            group.leave()
        }
        
        group.enter()
        fetchStatementData {
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.calculateNetBalance()
            self?.isLoadingPlaceholder = false
        }
    }
    
    private func fetchAllData() {
        resetAllData()
        
        self.firebaseDataService.fetchAllData { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .failure(let error):
                print("Fetch error: \(error.localizedDescription)")
                self.isLoadingPlaceholder = false
                
            case .success(let datas):
                self.companies = datas.0.sorted(by: { $0.id > $1.id })
                self.works = datas.1.sorted(by: { $0.id > $1.id })
                self.companyProducts = datas.2.sorted(by: { $0.date > $1.date })
                self.workProducts = datas.3.sorted(by: { $0.date > $1.date })
                self.statements = datas.4.sorted(by: { $0.date > $1.date })
                
                self.calculateNetBalance()
                self.isLoadingPlaceholder = false
                
                
            }
        }
    }
    
    private func fetchCompanyData(completion: (() -> Void)? = nil) {
        resetCompanyData()
        
        self.firebaseDataService.fetchCompanies { [weak self] result in
            guard let self = self else {
                completion?()
                return
            }
            
            switch result {
            case .failure(let error):
                print("Fetch error: \(error.localizedDescription)")
                self.isLoadingPlaceholder = false
                
            case .success(let companies):
                self.companies = companies.sorted(by: { $0.id > $1.id })
                self.isLoadingPlaceholder = false
            }
            
            completion?()
        }
    }
    
    private func fetchWorkData(completion: (() -> Void)? = nil) {
        resetWorkData()
        
        self.firebaseDataService.fetchWorks { [weak self] result in
            guard let self = self else {
                completion?()
                return
            }
            
            switch result {
            case .failure(let error):
                print("Fetch error: \(error.localizedDescription)")
                self.isLoadingPlaceholder = false
                
            case .success(let works):
                self.works = works.sorted(by: { $0.id > $1.id })
                self.isLoadingPlaceholder = false
            }
            
            completion?()
        }
    }
    
    private func fetchCompanyProductData(completion: (() -> Void)? = nil) {
        resetCompanyProductData()
        
        self.firebaseDataService.fetchCompanyProducts { [weak self] result in
            guard let self = self else {
                completion?()
                return
            }
            
            switch result {
            case .failure(let error):
                print("Fetch error: \(error.localizedDescription)")
                self.isLoadingPlaceholder = false
                
            case .success(let companyProducts):
                self.companyProducts = companyProducts.sorted(by: { $0.date > $1.date })
                self.isLoadingPlaceholder = false
            }
            
            completion?()
        }
    }
    
    private func fetchWorkProductData(completion: (() -> Void)? = nil) {
        resetWorkProductData()
        
        self.firebaseDataService.fetchWorkProducts { [weak self] result in
            guard let self = self else {
                completion?()
                return
            }
            
            switch result {
            case .failure(let error):
                print("Fetch error: \(error.localizedDescription)")
                self.isLoadingPlaceholder = false
                
            case .success(let workProducts):
                self.workProducts = workProducts.sorted(by: { $0.date > $1.date })
                self.isLoadingPlaceholder = false
            }
            
            completion?()
        }
    }
    
    private func fetchStatementData(completion: (() -> Void)? = nil) {
        resetStatementData()
        
        self.firebaseDataService.fetchStatements { [weak self] result in
            guard let self = self else {
                completion?()
                return
            }
            
            switch result {
            case .failure(let error):
                print("Fetch error: \(error.localizedDescription)")
                self.isLoadingPlaceholder = false
                
            case .success(let statements):
                self.statements = statements.sorted(by: { $0.date > $1.date })
                self.isLoadingPlaceholder = false
            }
            
            completion?()
        }
    }
    
    private func resetAllData() {
        resetCompanyData()
        resetWorkData()
        resetCompanyProductData()
        resetWorkProductData()
        resetStatementData()
    }
    
    private func resetCompanyData() {
        companies.removeAll()
    }
    
    private func resetWorkData() {
        works.removeAll()
    }
    
    private func resetCompanyProductData() {
        companyProducts.removeAll()
    }
    
    private func resetWorkProductData() {
        workProducts.removeAll()
    }
    
    private func resetStatementData() {
        statements.removeAll()
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
    
    func updateCompanyProductDetails(with product: CompanyProduct?) {
        companyProductDetails = CompanyProductDetails(from: product)
    }
    
    func updateWorkProductDetails(with product: CompanyProduct?) {
        workProductDetails = WorkProductDetails(from: product)
    }
    
    func companyCreate(company: Company) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.saveCompany(company)

                await MainActor.run {
                    self.fetchCompanyData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func companyUpdate(companyId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.updateCompany(companyId, updateArea: updateArea)

                await MainActor.run {
                    self.fetchCompanyData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func companyDelete(companyId: String) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.deleteCompany(companyId)

                await MainActor.run {
                    self.fetchCompanyData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func workCreate(work: Work) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.saveWork(work)

                await MainActor.run {
                    self.fetchWorkData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func workUpdate(workId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.updateWork(workId, updateArea: updateArea)

                await MainActor.run {
                    self.fetchWorkData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func workDelete(workId: String) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.deleteWork(workId)

                await MainActor.run {
                    self.fetchWorkData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func multipleWorkDelete(workIds: [String]) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteMultipleWork(workIds) { (error) in
            if let error = error {
                print("Toplu silme hatası: \(error.localizedDescription)")
                self.isLoadingPlaceholder = false
            } else {
                self.fetchWorkData()
            }
        }
    }
    
    func workProductCreate(product: WorkProduct) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.saveWorkProduct(product)

                await MainActor.run {
                    self.fetchWorkProductData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func workProductUpdate(productId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.updateWorkProduct(productId, updateArea: updateArea)

                await MainActor.run {
                    self.fetchWorkProductData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func workProductDelete(productId: String) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.deleteWorkProduct(productId)

                await MainActor.run {
                    self.fetchWorkProductData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func multipleWorkProductDelete(productIds: [String]) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteMultipleWorkProduct(productIds) { (error) in
            if let error = error {
                print("Toplu silme hatası: \(error.localizedDescription)")
                self.isLoadingPlaceholder = false
            } else {
                self.fetchWorkProductData()
            }
        }
    }
    
    func companyProductCreate(product: CompanyProduct) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.saveCompanyProduct(product)

                await MainActor.run {
                    self.fetchCompanyProductData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func companyProductUpdate(productId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.updateCompanyProduct(productId, updateArea: updateArea)

                await MainActor.run {
                    self.fetchCompanyProductData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func companyProductDelete(productId: String) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.deleteCompanyProduct(productId)

                await MainActor.run {
                    self.fetchCompanyProductData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func multipleCompanyProductDelete(productIds: [String]) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteMultipleCompanyProduct(productIds) { (error) in
            if let error = error {
                print("Toplu silme hatası: \(error.localizedDescription)")
                self.isLoadingPlaceholder = false
            } else {
                self.fetchCompanyProductData()
            }
        }
    }
    
    func statementCreate(statement: Statement) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.saveStatement(statement)

                await MainActor.run {
                    self.fetchStatementData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func statementUpdate(statementId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.updateStatement(statementId, updateArea: updateArea)

                await MainActor.run {
                    self.fetchStatementData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func statementDelete(statementId: String) {
        isLoadingPlaceholder = true
        Task {
            do {
                try await firebaseDataService.deleteStatement(statementId)

                await MainActor.run {
                    self.fetchStatementData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.isLoadingPlaceholder = false
                }
            }
        }
    }
    
    func multipleStatementDelete(statementIds: [String]) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteMultipleStatement(statementIds) { (error) in
            if let error = error {
                print("Toplu silme hatası: \(error.localizedDescription)")
                self.isLoadingPlaceholder = false
            } else {
                self.fetchStatementData()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func calculateNetBalance() {
        isLoadingPlaceholder = true
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
                    
                    let updateArea = [
                        "left": left
                    ]
                    
                    self.workUpdate(workId: work.id, updateArea: updateArea)
                    self.totalRevenue += work.cost
                    self.leftRevenue += left
                }
            }
            
            
        }
        
        self.traking = [
            Tracking(color: .green.opacity(0.85), value: self.totalRevenue - self.leftRevenue),
            Tracking(color: .red.opacity(0.85), value: self.leftRevenue)
        ]
        
        self.isLoadingPlaceholder = false
    }
    
    func openPhonePicker() {
        Task { @MainActor in
            let status = CNContactStore.authorizationStatus(for: .contacts)
            if status == .authorized {
                isPhonePicker = true
            }
        }
    }
    
    func saveUpdates(company: Company) {
        if companyDetails.name != company.name {
            if companies.first(where: { $0.name == companyDetails.name }) != nil {
                return
            }
        }
        
        let name = companyDetails.name.trim()
        let address = companyDetails.address.trim()
        let phone = companyDetails.phone
        let status = companyDetails.status
        
        let updateArea: [String : Any] = [
            "name": name,
            "address": address,
            "phone": phone,
            "status": status
        ]
        
        companyUpdate(companyId: company.id, updateArea: updateArea)
    }
    
}
