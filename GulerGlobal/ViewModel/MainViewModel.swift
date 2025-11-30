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
    
    @Published var companyList: [Company] = []
    @Published var works: [Work] = []
    
    @Published var allTasks: [TupleModel] = []
    @Published var pendingTasks: [TupleModel] = []
    @Published var approvedTasks: [TupleModel] = []
    @Published var rejectedTasks: [TupleModel] = []
    @Published var completedTasks: [TupleModel] = []
    

    @Published var allProducts: [Product] = []
    @Published var pendingProducts: [TupleModel] = []
    
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
        fetchCompanyData()
    }
    
    // MARK: - Public Methods
    func connectionControl() {
        isUserConnected = authService.getUid != nil
    }
    
    func fetchCompanyData() {
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
    
    func fetchWorkData() {
        isLoadingPlaceholder = true
        resetData()
        
        DispatchQueue.main.async {
            self.firebaseDataService.fetchWorks { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .failure(let error):
                    print("Fetch error: \(error.localizedDescription)")
                    self.isLoadingPlaceholder = false
                    
                case .success(let works):
                    self.works = works.sorted(by: { $0.id > $1.id })
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
        return companyList.filter { $0.name.lowercased().hasPrefix(name.lowercased()) }
    }
    
    func searchProducts(by name: String) -> [Product]? {
        guard !name.isEmpty else { return nil }
        return allProducts.filter { $0.name.lowercased().hasPrefix(name.lowercased()) }
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
        isLoadingPlaceholder = true
        firebaseDataService.saveCompany(company)
        fetchCompanyData()
    }
    func updateCompany(companyId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        firebaseDataService.updateCompany(companyId, updateArea: updateArea)
        fetchCompanyData()
    }
    func deleteCompany(companyId: String) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteCompany(companyId)
        fetchCompanyData()
    }
    func createWork(work: Work) {
        isLoadingPlaceholder = true
        firebaseDataService.saveWork(work)
        fetchWorkData()
    }
    func updateWork(workId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        firebaseDataService.updateWork(workId, updateArea: updateArea)
        fetchWorkData()
    }
    func deleteWork(workId: String) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteWork(workId)
        fetchWorkData()
    }
    
    func createWorkProduct(product: WorkProduct) {
        isLoadingPlaceholder = true
        firebaseDataService.saveWorkProduct(product)
        fetchCompanyData()
    }
    
    /*
     func updateCompanyProduct(productId: String, updateArea: [String: Any]) {
         isLoadingPlaceholder = true
         firebaseDataService.updateCompanyProduct(productId, updateArea: updateArea)
     }
     */
    
    func deleteWorkProduct(productId: String) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteWorkProduct(productId)
        fetchCompanyData()
    }
    func createCompanyProduct(product: Product) {
        isLoadingPlaceholder = true
        firebaseDataService.saveCompanyProduct(product)
        
         // let _ = OldPrice(price: product.price, date: product.date)
        // firebaseDataService.saveOldPrice(companyId, product.id, oldPrice)
        
        fetchCompanyData()
    }
    func updateCompanyProduct(productId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        firebaseDataService.updateCompanyProduct(productId, updateArea: updateArea)
        /*
         var price: Double?
         var date: Date?
         updateArea.forEach {
             if $0.key == "price" {
                 price = $0.value as? Double
             }
             
             if $0.key == "date" {
                 date = $0.value as? Date
             }
         }
         
         if let price = price {
             let _ = OldPrice(price: price, date: date ?? .now)
             // firebaseDataService.saveOldPrice(companyId, productId, oldPrice)
         }
         */
        fetchCompanyData()
    }
    func deleteCompanyProduct(productId: String) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteCompanyProduct(productId)
        fetchCompanyData()
    }
    func createStatement(statement: Statement) {
        isLoadingPlaceholder = true
        firebaseDataService.saveStatement(statement)
    }
    func updateStatement(statementId: String, updateArea: [String: Any]) {
        isLoadingPlaceholder = true
        firebaseDataService.updateStatement(statementId, updateArea: updateArea)
    }
    func deleteStatement(statementId: String) {
        isLoadingPlaceholder = true
        firebaseDataService.deleteStatement(statementId)
    }
    
    // MARK: - Private Methods
    
    private func resetData() {
        companyList.removeAll()
        allTasks.removeAll()
        pendingTasks.removeAll()
        approvedTasks.removeAll()
        rejectedTasks.removeAll()
        completedTasks.removeAll()

        allProducts.removeAll()
        
        pendingProducts.removeAll()
        totalRevenue = 0
        remainingRevenue = 0
    }
    
    private func processCompanies(_ companies: [Company]) {
        self.companyList = companies.sorted(by: { $0.id > $1.id })
        
        /*
         for _ in companies {
        
             
             /*
              
              var companyTotalMoney = 0.0
              var haveMoney = true
              
              for statement in company.statements {
                  if statement.status == .input || statement.status == .lend {
                      companyTotalMoney = companyTotalMoney + statement.amount
                  } else if statement.status == .output || statement.status == .debt {
                      companyTotalMoney = companyTotalMoney - statement.amount
                  }
              }
              */
             /*
              let workList = company.workList.sorted(by: { $0.id < $1.id })
              let finishedWorkList = company.workList.filter { $0.approve == .finished  }
              
              */
             /*
              for work in finishedWorkList {
                  companyTotalMoney = companyTotalMoney - work.totalCost
              }
              
              for work in workList {
              
                  if work.approve == .approved {
                      if companyTotalMoney > 0 && haveMoney {
                          companyTotalMoney = companyTotalMoney - work.totalCost
                         
                      } else {
                          companyTotalMoney = work.totalCost
                          haveMoney = false
                      }
                  }
                  
                  categorizeWork(work, company, companyTotalMoney: companyTotalMoney)
              }
              
              for product in company.productList {
                  allProducts.append(product)
              }
              */
             
         }
         
         pendingTasks.sort { $0.work.id > $1.work.id }
         approvedTasks.sort { $0.work.id > $1.work.id }
         rejectedTasks.sort { $0.work.id > $1.work.id }
         completedTasks.sort { $0.work.id > $1.work.id }
         
         traking = [
             Tracking(color: .green.opacity(0.85), value: totalRevenue - remainingRevenue),
             Tracking(color: .red.opacity(0.85), value: remainingRevenue)
         ]
         
         */
        isLoadingPlaceholder = false
    }
    
    private func categorizeWork(_ work: Work, _ company: Company, companyTotalMoney: Double) {
        let tuple = TupleModel(company: company, work: work)
  
        
        switch work.status {
        case .pending:
            pendingTasks.append(tuple)
        case .approved:
          
            /*
             var newWork = work

             if companyTotalMoney < 0 {
                 newWork.remainingBalance = -companyTotalMoney
             } else {
                 newWork.remainingBalance = companyTotalMoney
             }
             
             tuple = TupleModel(company: company, work: newWork)
             
             totalRevenue += work.totalCost
             remainingRevenue += newWork.remainingBalance

             */
       
            
            approvedTasks.append(tuple)
        case .rejected:
            rejectedTasks.append(tuple)
        case .finished:
            completedTasks.append(tuple)
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
    
    func companyConfirmation(dismiss: DismissAction, companyStatus: CompanyStatus) {
        guard
            companyDetails.name != "",
            companyDetails.address != ""
        else { return }
        
         if companyList.first(where: { $0.name == companyDetails.name }) != nil {
             hasAlert = true
         } else {
             
             let name = companyDetails.name.trim()
             let address = companyDetails.address.trim()
             let phone = companyDetails.phone
             
             let newCompany = Company(
                 id: generateUniqueID(isWork: false),
                 name: name,
                 address: address,
                 phone: phone,
                 status: companyStatus,
             )
             
             createCompany(company: newCompany)
             dismiss()
             
         }
    }
    
    func saveUpdates(company: Company) {
        if companyDetails.name != company.name {
            if companyList.first(where: { $0.name == companyDetails.name }) != nil {
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
        
        updateCompany(companyId: company.id, updateArea: updateArea)
    }
    
}

// MARK: - Supporting Models

struct CompanyDetails {
    var name: String = ""
    var address: String = ""
    var phone: String = ""
    var status: CompanyStatus = .current
    
    init() {}
    
    init(from company: Company?) {
        name = company?.name ?? ""
        address = company?.address ?? ""
        phone = company?.phone ?? ""
        status = company?.status ?? .current
    }
}

struct WorkDetails {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var cost: String = ""
    var status: ApprovalStatus = .pending
    var productList: [Product] = []
    var startDate: Date = .now
    var endDate: Date = .now
    var isChangeProjeNumber: Bool = true
    
    init() {}
    
    init(from work: Work?) {
        id = work?.id ?? ""
        name = work?.name ?? ""
        description = work?.description ?? ""
        cost = "\(work?.cost ?? 0)"
        status = work?.status ?? .pending
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
    var price: String = ""
    var quantity: String = ""
    var date: Date = .now
    var oldPrices: [OldPrice] = []
    
    init() {}
    
    init(from product: Product?) {
        name = product?.name ?? ""
        quantity = "\(product?.quantity ?? 0)"
        price = "\(product?.price ?? 0)"
        date = product?.date ?? .now
        oldPrices = product?.oldPrices ?? []
    }
}

