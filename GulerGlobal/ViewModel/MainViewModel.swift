//
//  MainViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 8.09.2024.
//

import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    
    let userConnection: AuthProtocol = UserConnection()
    private let dataModel: FirebaseDataModel = .init()
    
    @Published var tab: Tabs = .Home
    
    @Published var isPlaceHolder: Bool = false
    @Published var isConnected: Bool = false
    
    @Published var companies: [Company] = []
    
    @Published var works: [Work] = []
    @Published var waitWorks: [Work] = []
    @Published var approveWorks: [Work] = []
    @Published var unapproveWorks: [Work] = []
    @Published var finishedWorks: [Work] = []
    
    @Published var takenProducts: [Work] = []
    
    @Published var totalPrice: Double = 0
    @Published var totalRemPrice: Double = 0
    
    @Published var timePicker: Date = .now
    @Published var isPickerShower: Bool = false
    
    @Published var companyName: String = ""
    @Published var companyAddress: String = ""
    @Published var companyPhone: String = ""
    
    @Published var workPNum: String = ""
    @Published var workName: String = ""
    @Published var workDesc: String = ""
    @Published var workPrice: String = ""
    @Published var workRec: String = ""
    @Published var acceptRem: String = ""
    @Published var workExp: String = ""
    @Published var workApprove: String = ""
    
    @Published var acceptStart: Date = .now
    @Published var acceptFinished: Date = .now
    
    @Published var givrecPrice: String = ""
    
    @Published var givrecDate: Date = .now
    
    @Published var proName: String = ""
    @Published var proQuantity: String = ""
    @Published var proPrice: String = ""
    @Published var proSuggestion: String = ""
    
    @Published var productList: [Product] = []
    @Published var proPurchasedDate: Date = .now
    
    @Published var workRecDate: Date = .now
    @Published var recList: [Statement] = []
    
    @Published var workExpDate: Date = .now
    @Published var expList: [Statement] = []

    @Published var isNewCompany: Bool = true
    @Published var isPNum: Bool = true
    
    @Published var traking: [Tracking] = []
    @Published var isAnimated: Bool = false
    
    @Published var hasAlert: Bool = false
    
    init() {
        fetchData()
        connectionControl()
    }
    
    func connectionControl() {
        if self.userConnection.getUid != nil {
            self.isConnected = true
        }
    }
    
    func fetchData() {
        isPlaceHolder = true
        
        companies = []
        
        works = []
        waitWorks = []
        approveWorks = []
        unapproveWorks = []
        finishedWorks = []
        takenProducts = []
        productList = []
        
        totalPrice = 0
        totalRemPrice = 0
        
        DispatchQueue.main.async {
            self.dataModel.fetchCompaniesData { companyResult  in
       
                switch companyResult {
                    
                case .failure(let companyError):
                    
                    print(companyError.localizedDescription)
                    self.isPlaceHolder = false
                    
                case .success(let companies):
                    
                    self.companies = companies
                    
                    self.dataModel.fetchWorksData { workResult in
                        
                        switch workResult {
                            
                        case .failure(let workError):
                            
                            print(workError.localizedDescription)
                            self.isPlaceHolder = false
                            
                        case .success(let works):
                            
                            self.works = works
                            
                            for work in works {
                                
                                switch work.approve {
                                    
                                case "Wait":
                                    
                                    self.waitWorks.append(work)
                                    
                                case "Approve":
                                    
                                    self.approveWorks.append(work)
                                    
                                    self.totalRemPrice += work.accept.remMoney
                                    
                                    self.totalPrice += work.price
                                    
                                case "Unapprove":
                                    
                                    self.unapproveWorks.append(work)
                                    
                                case "Finished":
                                    
                                    self.finishedWorks.append(work)
                                    
                                default:
                                    
                                    print("Not found any information!")
                                    
                                }
                                
                                if work.products.contains(where: { !$0.isBought }) {
                                    self.takenProducts.append(work)
                                }
                            }
                            
                            self.waitWorks = self.waitWorks.sorted(by: { $0.id > $1.id })
                            self.approveWorks = self.approveWorks.sorted(by: { $0.id > $1.id })
                            self.unapproveWorks = self.unapproveWorks.sorted(by: { $0.id > $1.id })
                            self.finishedWorks = self.finishedWorks.sorted(by: { $0.id > $1.id })
                            self.companies = self.companies.sorted(by: { $0.id > $1.id })
                            
                            self.isPlaceHolder = false
                            self.traking = [
                                .init(color: .green, value: (self.totalPrice - self.totalRemPrice)),
                                .init(color: .red, value: self.totalRemPrice)]
                        }
                    }
                    
                }
                
            }
        }
    }
    
    func generateProjectNumber() -> String? {
        var projectNumber = 0
        for work in works {
            if Int(work.id) ?? 0 > projectNumber {
                projectNumber = Int(work.id) ?? 0
            }
        }
        
        projectNumber = projectNumber + 1
        var string = "\(projectNumber)"
        for _ in 0...(3 - string.count){
            string = "0" + string
        }
        
        return string
    }
    
    func generateCompanyId() -> String? {
        var companyId = 0
        for company in companies {
            if Int(company.id) ?? 0 > companyId {
                companyId = Int(company.id) ?? 0
            }
        }
        
        companyId = companyId + 1
        
        return "\(companyId)"
    }
    
    func searchCompanies(_ value: String) -> [Company]? {
        var newCompanies = [Company]()
        
        for i in companies {
            if !newCompanies.contains(where: {$0.name == i.name }) {
                newCompanies.append(i)
            }
        }
        
        return value == "" ? nil : newCompanies.filter({ $0.name.lowercased().hasPrefix(value.lowercased()) })
    }
    
    func getCompanyById(_ companyId: String) -> Company {
        var newCompany: Company = Company(
            id: "0",
            name: "none",
            address: "none",
            phone: "none",
            works: [String]()
        )
        
        for company in companies {
            if companyId == company.id {
                newCompany = company
            }
        }
        
        return newCompany
    }
    
    func getWorkById(_ workId: String) -> Work {
        var newWork: Work = Work(
            id: "0000",
            companyId: "0",
            name: "none",
            desc: "none",
            price: 0,
            approve: "Wait",
            accept: .init(
                remMoney: 0,
                recList: [],
                expList: [],
                start: .now,
                finished: .now),
            products: []
        )
        
        for work in works {
            if workId == work.id {
                newWork = work
            }
        }
        
        return newWork
    }
    
    func companyChange(_ company: Company?) {
        if let company = company {
            companyName = company.name
            companyAddress = company.address
            companyPhone = company.phone
        } else {
            companyName = ""
            companyAddress = ""
            companyPhone = ""
        }
    }
    
    func workChange(_ work: Work?) {
        if let work = work {
            workPNum = work.id
            workName = work.name
            workDesc = work.desc
            workPrice = "\(work.price)"
            workApprove = work.approve
            productList = work.products
            
            acceptRem = "\(work.accept.remMoney)"
            recList = work.accept.recList
            expList = work.accept.expList
            acceptStart = work.accept.start
            acceptFinished = work.accept.finished
            
        } else {
            workPNum = ""
            workName = ""
            workDesc = ""
            workPrice = ""
            workApprove = ""
            productList = []
            acceptRem = ""
            recList = []
            expList = []
            acceptStart = .now
            acceptFinished = .now
        }
    }
    
    func givrecChange(_ givrec: Givrec?) {
        if let givrec = givrec {
            givrecPrice = "\(givrec.price)"
            givrecDate = givrec.date
        } else {
            workPrice = ""
            givrecDate = .now
        }
    }
    
    func createCompany() {
        isPlaceHolder = true
        
        let companyId = generateCompanyId() ?? "0"
        
        isPlaceHolder = dataModel.createCompany(
            Company(
                id: companyId,
                name: companyName,
                address: companyAddress,
                phone: companyPhone,
                works: []
            )
        )
        
        /*
         ,
         work: Work(
             id: workPNum,
             companyId: companyId,
             name: workName,
             desc: workDesc,
             price: price,
             approve: workApprove,
             accept: .init(
                 remMoney: price,
                 recList: [],
                 expList: [],
                 start: .now,
                 finished: .now),
             products: []
         )
         */
        
        fetchData()
    }
    
    func updateCompany(_ company: Company) {
        isPlaceHolder = true
        isPlaceHolder = dataModel.updateCompany(company)
        
        fetchData()
    }
    
    func createWork(_ companyId: String) {
        isPlaceHolder = true
        
        var workList: [String] = []
        
        let price = Double(workPrice) ?? 0
        
        for company in companies {
            if company.id == companyId {
                workList = company.works
            }
        }
        
        workList.append(workPNum)
        
        isPlaceHolder = dataModel.createWork(
            Work(
                id: workPNum,
                companyId: companyId,
                name: workName,
                desc: workDesc,
                price: price,
                approve: workApprove,
                accept: .init(
                    remMoney: price,
                    recList: [],
                    expList: [],
                    start: .now,
                    finished: .now),
                products: []
            )
        )
        
        /*
         company: Company(
             id: companyId,
             name: companyName,
             address: companyAddress,
             phone: companyPhone,
             works: workList
         ),
         */
        
        fetchData()
    }
    
    func updateWork(_ work: Work) {
        isPlaceHolder = true
        isPlaceHolder = dataModel.updateWork(work)
        
        fetchData()
    }
    
    func editProduct(_ isBought: Bool, product: Product, work: Work) {
        productList = []
        
        let newProduct = Product(
            name: product.name,
            quantity: product.quantity,
            price: product.price,
            suggestion: product.suggestion,
            purchased: product.purchased,
            isBought: true)
        
        for pro in work.products {
            if pro.name != product.name {
                productList.append(pro)
            }
        }
        
        if isBought {
            productList.append(newProduct)
        }
        
        updateWork(.init(
            id: work.id,
            companyId: work.companyId,
            name: work.name,
            desc: work.desc,
            price: work.price,
            approve: work.approve,
            accept: .init(
                remMoney: work.accept.remMoney,
                recList: work.accept.recList,
                expList: work.accept.expList,
                start: work.accept.start,
                finished: work.accept.finished),
            products: productList))
    }
    
    func editStatement(_ isRec: Bool, list: [Statement], statement: Statement, work: Work) {
        var newList = list
        if let index = list.firstIndex(of: statement) {
            newList.remove(at: index)
    
            var remMoney = work.price
            var newRecList = work.accept.recList
            
            newRecList.append(statement)
            
            if isRec {
                for rec in newList {
                    remMoney -= rec.price
                }
            } else {
                for rec in newRecList {
                    remMoney -= rec.price
                }
            }
            
            updateWork(.init(
                id: work.id,
                companyId: work.companyId,
                name: work.name,
                desc: work.desc,
                price: work.price,
                approve: work.approve,
                accept: .init(
                    remMoney: remMoney,
                    recList: isRec ? newList : newRecList,
                    expList: isRec ? work.accept.expList : newList,
                    start: work.accept.start,
                    finished: work.accept.finished),
                products: productList))
            
        }
    }
    
    func remMoneySnapping(price: Double, work: Work) {
        var totalPrice = price
        for rec in work.accept.recList {
            totalPrice -= rec.price
        }
        acceptRem = "\(totalPrice)"
    }

}
