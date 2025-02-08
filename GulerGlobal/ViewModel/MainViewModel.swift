//
//  MainViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 8.09.2024.
//

import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    // MARK: - Dependencies
    let authService: AuthProtocol = UserConnection()
    private let firebaseDataService = FirebaseDataModel()
    
    // MARK: - Published Properties
    @Published var activeTab: TabValue = .Home
    @Published var tabAnimationTrigger: TabValue?
    @Published var isTabBarHidden: Bool = false
    @Published var isNewCompany: Bool = false
    
    @Published var isLoadingPlaceholder: Bool = false
    @Published var isUserConnected: Bool = false
    
    @Published var companyList: [Company] = []
    
    @Published var allTasks: [TupleModel] = []
    @Published var pendingTasks: [TupleModel] = []
    @Published var approvedTasks: [TupleModel] = []
    @Published var rejectedTasks: [TupleModel] = []
    @Published var completedTasks: [TupleModel] = []
    
    @Published var pendingProducts: [TupleModel] = []
    
    @Published var productList: [Product] = []
    
    @Published var totalRevenue: Double = 0
    @Published var remainingRevenue: Double = 0
    
    @Published var companyDetails = CompanyDetails()
    @Published var workDetails = WorkDetails()
    @Published var productDetails = ProductDetails()
    @Published var traking: [Tracking] = []
    @Published var isAnimated: Bool = false
    @Published var hasAlert: Bool = false
    
    @Published var acceptRem: String = ""
    
    // MARK: - Initializer
    init() {
        connectionControl()
        fetchData()
    }
    
    // MARK: - Public Methods
    func connectionControl() {
        isUserConnected = authService.getUid != nil
    }
    
    func fetchData() {
        isLoadingPlaceholder = true
        resetData()
        
        DispatchQueue.main.async {
            self.firebaseDataService.fetchCompanies { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .failure(let error):
                    print("Fetch error: \(error.localizedDescription)")
                    self.isLoadingPlaceholder = false
                    
                case .success(let companies):
                    self.processCompanies(companies)
                }
            }
        }
    }
    
    func generateUniqueID(isWork: Bool = true) -> String {
        let highestID = isWork
        ? allTasks.compactMap {  Int($0.work.id) }.max() ?? 0
        : companyList.compactMap {  Int($0.id) }.max() ?? 0
        return isWork ? String(format: "%04d", highestID + 1) : String(highestID + 1)
    }
    
    func searchCompanies(by name: String) -> [Company]? {
        guard !name.isEmpty else { return nil }
        return companyList.filter { $0.companyName.lowercased().hasPrefix(name.lowercased()) }
    }
    
    func updateCompanyDetails(with company: Company?) {
        companyDetails = CompanyDetails(from: company)
    }
    
    func updateWorkDetails(with work: Work?) {
        workDetails = WorkDetails(from: work)
    }
    
    func updateProductDetails(with product: Product?) {
        productDetails = ProductDetails(from: product)
    }
    
    func createCompany() {
        guard !companyDetails.name.isEmpty else { return }
        isLoadingPlaceholder = true
        
        let newCompany = Company(
            id: generateUniqueID(isWork: false),
            companyName: companyDetails.name,
            companyAddress: companyDetails.address,
            contactNumber: companyDetails.contactNumber,
            workList: []
        )
        
        isLoadingPlaceholder = firebaseDataService.saveCompany(newCompany)
        fetchData()
    }
    func updateCompany(companyId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        
        isLoadingPlaceholder = firebaseDataService.updateCompany(companyId, updateArea: updateArea)
        
        fetchData()
    }
    func createWork(companyId: String, work: Work) {
        isLoadingPlaceholder = true
        
        isLoadingPlaceholder = firebaseDataService.saveWork(companyId, work)
        
        fetchData()
    }
    func updateWork(companyId: String, workId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        
        isLoadingPlaceholder = firebaseDataService.updateWork(companyId, workId, updateArea: updateArea)
        
        fetchData()
    }
    func deleteWork(companyId: String, workId: String) {
        isLoadingPlaceholder = true
        
        isLoadingPlaceholder = firebaseDataService.deleteWork(companyId, workId)
        
        fetchData()
    }
    func createProduct(companyId: String, workId: String, product: Product) {
        isLoadingPlaceholder = true
        
        isLoadingPlaceholder = firebaseDataService.saveProduct(companyId, workId, product)
        
        fetchData()
    }
    func updateProduct(companyId: String, workId: String, productId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        
        isLoadingPlaceholder = firebaseDataService.updateProduct(companyId, workId, productId, updateArea: updateArea)
        
        fetchData()
    }
    func deleteProduct(companyId: String, workId: String, productId: String) {
        isLoadingPlaceholder = true
        
        isLoadingPlaceholder = firebaseDataService.deleteProduct(companyId, workId, productId)
        
        fetchData()
    }
    func createStatement(companyId: String, workId: String, statement: Statement) {
        isLoadingPlaceholder = true
        
        isLoadingPlaceholder = firebaseDataService.saveStatement(companyId, workId, statement)
    }
    func updateStatement(companyId: String, workId: String, statementId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        
        isLoadingPlaceholder = firebaseDataService.updateStatement(companyId, workId, statementId, updateArea: updateArea)
    }
    func deleteStatement(companyId: String, workId: String, statementId: String) {
        isLoadingPlaceholder = true
        
        isLoadingPlaceholder = firebaseDataService.deleteStatement(companyId, workId, statementId)
    }
    
    // MARK: - Private Methods
    
    private func resetData() {
        companyList.removeAll()
        allTasks.removeAll()
        pendingTasks.removeAll()
        approvedTasks.removeAll()
        rejectedTasks.removeAll()
        completedTasks.removeAll()
        pendingProducts.removeAll()
        productList.removeAll()
        totalRevenue = 0
        remainingRevenue = 0
    }
    
    private func processCompanies(_ companies: [Company]) {
        self.companyList = companies.sorted(by: { $0.id > $1.id })
        
        for company in companies {
            for work in company.workList {
                categorizeWork(work, for: company)
            }
        }
        
        pendingTasks.sort { $0.work.id > $1.work.id }
        approvedTasks.sort { $0.work.id > $1.work.id }
        rejectedTasks.sort { $0.work.id > $1.work.id }
        completedTasks.sort { $0.work.id > $1.work.id }
        
        traking = [
            Tracking(color: .green, value: totalRevenue - remainingRevenue),
            Tracking(color: .red, value: remainingRevenue)
        ]
        
        isLoadingPlaceholder = false
    }
    
    private func categorizeWork(_ work: Work, for company: Company) {
        let tuple = TupleModel(company: company, work: work)
        
        switch work.approve {
        case .none:
            print("Invalid approval status")
        case .pending:
            pendingTasks.append(tuple)
        case .approved:
            approvedTasks.append(tuple)
            remainingRevenue += work.remainingBalance
            totalRevenue += work.totalCost
        case .rejected:
            rejectedTasks.append(tuple)
        case .finished:
            completedTasks.append(tuple)
        }
        
        if work.productList.contains(where: { !$0.isBought }) {
            pendingProducts.append(tuple)
        }
        allTasks.append(tuple)
    }
    
    func remMoneySnapping(price: Double, statements: [Statement]) -> Double {
        var totalPrice = price
        for statement in statements {
            if statement.status == .received {
                totalPrice -= statement.amount
            }
        }
        
        return totalPrice
    }
}

// MARK: - Supporting Models

struct CompanyDetails {
    var name: String = ""
    var address: String = ""
    var contactNumber: String = ""
    
    init() {}
    
    init(from company: Company?) {
        name = company?.companyName ?? ""
        address = company?.companyAddress ?? ""
        contactNumber = company?.contactNumber ?? ""
    }
}

struct WorkDetails {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var totalCost: String = ""
    var approve: ApprovalStatus = .none
    var startDate: Date = .now
    var endDate: Date = .now
    var statementAmount: String = ""
    var statementDate: Date = .now
    var isChangeProjeNumber: Bool = true
    
    init() {}
    
    init(from work: Work?) {
        id = work?.id ?? ""
        name = work?.workName ?? ""
        description = work?.workDescription ?? ""
        totalCost = "\(work?.totalCost ?? 0)"
        approve = work?.approve ?? .none
        startDate = work?.startDate ?? .now
        endDate = work?.endDate ?? .now
    }
}

struct ProductDetails {
    var name: String = ""
    var quantity: String = ""
    var unitPrice: String = ""
    var suggestion: String = ""
    var purchased: Date = .now
    
    init() {}
    
    init(from product: Product?) {
        name = product?.productName ?? ""
        quantity = "\(product?.quantity ?? 0)"
        unitPrice = "\(product?.unitPrice ?? 0)"
        suggestion = product?.suggestion ?? ""
        purchased = product?.purchased ?? .now
    }
}

