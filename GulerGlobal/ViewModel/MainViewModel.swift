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
    @Published var tabAnimationTrigger: TabValue?
    
    @Published var isLoadingPlaceholder: Bool = false
    @Published var isUserConnected: Bool = false
    
    @Published var companyTotalMoney = 0.0
    @Published var companyList: [Company] = []
    
    @Published var allTasks: [TupleModel] = []
    @Published var pendingTasks: [TupleModel] = []
    @Published var approvedTasks: [TupleModel] = []
    @Published var rejectedTasks: [TupleModel] = []
    @Published var completedTasks: [TupleModel] = []
    
    @Published var statementTasks: [StatementTupleModel] = []

    @Published var allProducts: [Product] = []
    @Published var pendingProducts: [TupleModel] = []
    
    @Published var allStatements: [Statement] = []
    
    @Published var totalRevenue: Double = 0
    @Published var remainingRevenue: Double = 0
    
    @Published var companyDetails = CompanyDetails()
    @Published var workDetails = WorkDetails()
    @Published var productDetails = ProductDetails()
    @Published var statementDetails = StatementDetails()
    
    @Published var traking: [Tracking] = []
    @Published var isAnimated: Bool = false
    @Published var hasAlert: Bool = false
    
    @Published var isPhonePicker: Bool = false
    
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
    
    func searchProducts(by name: String) -> [Product]? {
        guard !name.isEmpty else { return nil }
        return allProducts.filter { $0.productName.lowercased().hasPrefix(name.lowercased()) }
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
    
    func createCompany(company: Company) {
        guard !companyDetails.name.isEmpty else { return }
        isLoadingPlaceholder = true
        firebaseDataService.saveCompany(company)
        createWork(companyId: company.id, work: example_Work)
    }
    func updateCompany(companyId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        firebaseDataService.updateCompany(companyId, updateArea: updateArea)
        fetchData()
    }
    func deleteCompany(companyId: String) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteCompany(companyId)
        fetchData()
    }
    func createWork(companyId: String, work: Work) {
        isLoadingPlaceholder = true
        firebaseDataService.saveWork(companyId, work)
        fetchData()
    }
    func updateWork(companyId: String, workId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        firebaseDataService.updateWork(companyId, workId, updateArea: updateArea)
        fetchData()
    }
    func deleteWork(companyId: String, workId: String) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteWork(companyId, workId)
        fetchData()
    }
    
    func createProductForWork(companyId: String, workId: String, product: Product) {
        isLoadingPlaceholder = true
        firebaseDataService.saveProduct(companyId, workId, product)
        fetchData()
    }
    
    func updateProductForCompany(companyId: String, productId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        firebaseDataService.updateProduct(companyId, nil, productId, updateArea: updateArea)
    }
    
    func deleteProductForWork(companyId: String, workId: String, productId: String) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteProduct(companyId, workId, productId)
        fetchData()
    }
    func createProduct(companyId: String, product: Product) {
        isLoadingPlaceholder = true
        firebaseDataService.saveProduct(companyId, nil, product)
        
        let oldPrice = OldPrice(price: product.unitPrice, date: product.purchased)
        firebaseDataService.saveOldPrice(companyId, product.id, oldPrice)
        
        fetchData()
    }
    func updateProduct(companyId: String, productId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        firebaseDataService.updateProduct(companyId, nil, productId, updateArea: updateArea)
        var price: Double?
        var date: Date?
        updateArea.forEach {
            if $0.key == "unitPrice" {
                price = $0.value as? Double
            }
            
            if $0.key == "purchased" {
                date = $0.value as? Date
            }
        }
        
        if let price = price {
            let oldPrice = OldPrice(price: price, date: date ?? .now)
            firebaseDataService.saveOldPrice(companyId, productId, oldPrice)
        }
        fetchData()
    }
    func deleteProduct(companyId: String, productId: String) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteProduct(companyId,nil , productId)
        fetchData()
    }
    func createStatement(companyId: String, statement: Statement) {
        isLoadingPlaceholder = true
        firebaseDataService.saveStatement(companyId, statement)
    }
    func updateStatement(companyId: String, statementId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        firebaseDataService.updateStatement(companyId, statementId, updateArea: updateArea)
    }
    func deleteStatement(companyId: String, statementId: String) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteStatement(companyId, statementId)
    }
    func deleteOldPrice(companyId: String, productId: String, oldPriceAId: String) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteOldPrice(companyId, productId, oldPriceAId)
        fetchData()
    }
    
    // MARK: - Private Methods
    
    private func resetData() {
        companyList.removeAll()
        allTasks.removeAll()
        pendingTasks.removeAll()
        approvedTasks.removeAll()
        rejectedTasks.removeAll()
        completedTasks.removeAll()
        statementTasks.removeAll()
        allProducts.removeAll()
        allStatements.removeAll()
        pendingProducts.removeAll()
        totalRevenue = 0
        remainingRevenue = 0
    }
    
    private func processCompanies(_ companies: [Company]) {
        self.companyList = companies.sorted(by: { $0.id > $1.id })
        
        for company in companies {
            let statementTupleModel = StatementTupleModel(companyId: company.id, statement: company.statements)
            statementTasks.append(statementTupleModel)
            
            for work in company.workList {
                categorizeWork(work, for: company)
            }
            
            for statement in company.statements {
                if statement.status == .input || statement.status == .lend {
                    companyTotalMoney += statement.amount
                }
                else if statement.status == .output || statement.status == .debt {
                    companyTotalMoney -= statement.amount
                }
            }
        }
        
        pendingTasks.sort { $0.work.id > $1.work.id }
        approvedTasks.sort { $0.work.id > $1.work.id }
        rejectedTasks.sort { $0.work.id > $1.work.id }
        completedTasks.sort { $0.work.id > $1.work.id }
        
        traking = [
            Tracking(color: .green.opacity(0.85), value: totalRevenue - remainingRevenue),
            Tracking(color: .red.opacity(0.85), value: remainingRevenue)
        ]
        
        isLoadingPlaceholder = false
    }
    
    private func categorizeWork(_ work: Work, for company: Company) {
        let tuple = TupleModel(company: company, work: work)
        
        switch work.approve {
        case .none:
             print("none")
        case .pending:
            pendingTasks.append(tuple)
        case .approved:
            approvedTasks.append(tuple)
            totalRevenue += work.totalCost
        case .rejected:
            rejectedTasks.append(tuple)
        case .finished:
            completedTasks.append(tuple)
        }
        
        for product in company.productList {
            allProducts.append(product)
        }
        
         for statement in company.statements {
             if statement.status == .debt || statement.status == .lend {
                 allStatements.append(statement)
             }
         }
         
        allTasks.append(tuple)
    }
    
    func openPhonePicker() {
        Task { @MainActor in
            let status = CNContactStore.authorizationStatus(for: .contacts)
            
            switch status {
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            case .authorized:
                isPhonePicker = true
            case .limited:
                print("limited")
            @unknown default:
                print("default denied")
            }
        }
    }
    
    func companyConfirmation(dismiss: DismissAction, partnerRole: PartnerRole) {
        guard
            companyDetails.name != "",
            companyDetails.address != ""
        else { return }
        
        if companyList.first(where: { $0.companyName == companyDetails.name }) != nil {
            hasAlert = true
        } else {
            
            let companyName = companyDetails.name.trim()
            let companyAddress = companyDetails.address.trim()
            let contactNumber = companyDetails.contactNumber
            
            let newCompany = Company(
                id: generateUniqueID(isWork: false),
                companyName: companyName,
                companyAddress: companyAddress,
                contactNumber: contactNumber,
                partnerRole: partnerRole,
                workList: [],
                statements: [],
                productList: []
            )
            
            createCompany(company: newCompany)
            dismiss()
            
        }
    }
    
    func saveUpdates(company: Company) {
        if companyDetails.name != company.companyName {
            if companyList.first(where: { $0.companyName == companyDetails.name }) != nil {
                return
            }
        }
        
        let companyName = companyDetails.name.trim()
        let companyAddress = companyDetails.address.trim()
        let contactNumber = companyDetails.contactNumber
        let partnerRoleRawValue = companyDetails.partnerRole.rawValue
        
        let updateArea = [
            "companyName": companyName,
            "companyAddress": companyAddress,
            "contactNumber": contactNumber,
            "partnerRole": partnerRoleRawValue
        ]
        
        updateCompany(companyId: company.id, updateArea: updateArea)
    }
    
}

// MARK: - Supporting Models

struct CompanyDetails {
    var name: String = ""
    var address: String = ""
    var contactNumber: String = ""
    var partnerRole: PartnerRole = .none
    
    init() {}
    
    init(from company: Company?) {
        name = company?.companyName ?? ""
        address = company?.companyAddress ?? ""
        contactNumber = company?.contactNumber ?? ""
        partnerRole = company?.partnerRole ?? .none
    }
}

struct WorkDetails {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var totalCost: String = ""
    var approve: ApprovalStatus = .none
    var productList: [Product] = []
    var startDate: Date = .now
    var endDate: Date = .now
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

struct StatementDetails {
    var amount: String = ""
    var date: Date = .now
    
    init() {}
    
    init(from statement: Statement?) {
        amount = "\(statement?.amount ?? 0)"
        date = statement?.date ?? .now
    }
}

struct ProductDetails {
    var supplier: String = ""
    var name: String = ""
    var unitPrice: String = ""
    var quantity: String = ""
    var purchased: Date = .now
    var oldPrices: [OldPrice] = []
    
    init() {}
    
    init(from product: Product?) {
        supplier = product?.supplier ?? ""
        name = product?.productName ?? ""
        quantity = "\(product?.quantity ?? 0)"
        unitPrice = "\(product?.unitPrice ?? 0)"
        purchased = product?.purchased ?? .now
    }
}

