//
//  FirebaseDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import FirebaseFirestore

@MainActor
final class FirebaseDataModel: ObservableObject {
    private let db = Firestore.firestore()
    let userConnection : AuthProtocol = UserConnection()
    
    @Published var isConnected : Bool = false
    
    @Published var companies: [Company] = []
    @Published var waitCompanies: [Company] = []
    @Published var approveCompanies: [Company] = []
    @Published var unapproveCompanies: [Company] = []
    @Published var finishedCompanies: [Company] = []
    
    @Published var takenProducts: [Company] = []
    
    @Published var totalPrice: Double = 0
    @Published var totalRemPrice: Double = 0
    @Published var isPlaceHolder: Bool = false
    
    @Published var proName: String = ""
    @Published var proQuantity: String = ""
    @Published var proPrice: String = ""
    @Published var proSuggestion: String = ""
    
    @Published var workPNum: String = ""
    @Published var workName: String = ""
    @Published var workDesc: String = ""
    @Published var workPrice: String = ""
    @Published var workRec: String = ""
    @Published var workRem: String = ""
    @Published var workExp: String = ""
    @Published var workApprove: String = ""
    
    
    @Published var companyName: String = ""
    @Published var companyAddress: String = ""
    @Published var companyPhone: String = ""
    
    @Published var workStartDate: Date = .now
    @Published var workFinishDate: Date = .now
    
    @Published var productList: [Product] = []
    @Published var proPurchasedDate: Date = .now
    
    @Published var workRecDay: Date = .now
    @Published var recDateList: [Statement] = []
    
    @Published var workExpiryDay: Date = .now
    @Published var expDateList: [Statement] = []
    
    
    @Published var isPickerShower: Bool = false
    
    @Published var isNewCompany: Bool = true
    @Published var isPNum: Bool = true
    
    @Published var isExpiry: Bool = false
    @Published var formTitle: FormTitle = .none
    
    init() {
        fetchData()
        
        if self.userConnection.getUid != nil {
            self.isConnected = true
        }
        
    }
    
    func getLastPNum() -> String? {
        var intPnum = 0
        for company in companies {
            if Int(company.work.id) ?? 0 > intPnum {
                intPnum = Int(company.work.id) ?? 0
            }
        }
        
        intPnum = intPnum + 1
        var stringPnum = "\(intPnum)"
        for _ in 0...(3 - stringPnum.count){
            stringPnum = "0" + stringPnum
        }
        
        return stringPnum
    }
    
    func fetchCompany(value: String) -> [Company]? {
        var newCompanies = [Company]()
        for i in companies {
            if !newCompanies.contains(where: {$0.name == i.name }) {
                newCompanies.append(i)
            }
        }
        return value == "" ? nil : newCompanies.filter({ $0.name.lowercased().hasPrefix(value.lowercased()) })
    }
    
    // Pulls data from Core Data.
    @MainActor
    func fetchData() {
        let docRef = db.collection("Company")
        waitCompanies = []
        approveCompanies = []
        unapproveCompanies = []
        finishedCompanies = []
        takenProducts = []
        
        totalPrice = 0
        totalRemPrice = 0
        
        isPlaceHolder = true
        
        Task {
            do {
                let companies = try await docRef.getDocuments()
                
                for company in companies.documents {
                    
                    if let work = company.data()["work"] as? [String: Any]  {
                        
                        if let accept = work["accept"] as? [String: Any] {
                            var recList: [Statement] = []
                            for rec in accept["recList"] as? [[String: Any]] ?? [] {
                                let date = rec["date"] as? Timestamp ?? .init(date: .now)
                                let price = rec["price"] as? Double ?? 0
                                recList.append(Statement(date: date.dateValue(), price: price))
                            }
                            
                            var expList: [Statement] = []
                            for rec in accept["expList"] as? [[String: Any]] ?? [] {
                                let date = rec["date"] as? Timestamp ?? .init(date: .now)
                                let price = rec["price"] as? Double ?? 0
                                expList.append(Statement(date: date.dateValue(), price: price))
                            }
                            
                            var proList: [Product] = []
                            for pro in work["product"] as? [[String: Any]] ?? [] {
                                let name = pro["name"] as? String ?? ""
                                let quantity = pro["quantity"] as? Int ?? 0
                                let price = pro["price"] as? Double ?? 0
                                let suggestion = pro["suggestion"] as? String ?? ""
                                let purchased = pro["purchased"] as? Timestamp ?? .init(date: .now)
                                let isBought = pro["isBought"] as? Bool ?? false
                                proList.append(Product(name: name, quantity: quantity, price: price, suggestion: suggestion, purchased: purchased.dateValue(), isBought: isBought))
                            }
                            
                            let newWork = Work(
                                id: work["id"] as? String ?? "",
                                name: work["name"] as? String ?? "",
                                desc: work["desc"] as? String ?? "",
                                price: work["price"] as? Double ?? 0,
                                approve: work["approve"] as? String ?? "",
                                accept: Accept(
                                    remMoney: accept["remMoney"] as? Double ?? 0,
                                    isExpiry: accept["isExpiry"] as? Bool ?? false,
                                    recList: recList,
                                    expList: expList,
                                    startDate: accept["startDate"] as? Date ?? .now,
                                    finishDate: accept["finishDate"] as? Date ?? .now),
                                product: proList)
                            
                            let newCompany = Company(
                                name: company.data()["name"] as? String ?? "",
                                address: company.data()["address"] as? String ?? "",
                                phone: company.data()["phone"] as? String ?? "",
                                work: newWork)
                            
                            switch newCompany.work.approve {
                            case "Wait":
                                self.waitCompanies.append(newCompany)
                            case "Approve":
                                self.approveCompanies.append(newCompany)
                                self.totalRemPrice += newCompany.work.accept.remMoney
                                self.totalPrice += newCompany.work.price
                            case "Unapprove":
                                self.unapproveCompanies.append(newCompany)
                            case "Finished":
                                self.finishedCompanies.append(newCompany)
                            default:
                                print("Not found any information!")
                            }
                            
                            for p in newCompany.work.product {
                                if !p.isBought {
                                    if !self.takenProducts.contains(where: { c in c == newCompany}) {
                                        self.takenProducts.append(newCompany)
                                    }
                                }
                            }
                            self.companies.append(newCompany)
                            
                        }
                    }
                }
                
                self.waitCompanies = self.waitCompanies.sorted(by: { $0.work.id > $1.work.id })
                self.approveCompanies = self.approveCompanies.sorted(by: { $0.work.id > $1.work.id })
                self.unapproveCompanies = self.unapproveCompanies.sorted(by: { $0.work.id > $1.work.id })
                self.finishedCompanies = self.finishedCompanies.sorted(by: { $0.work.id > $1.work.id })
                self.companies = self.companies.sorted(by: { $0.work.id > $1.work.id })
                
                isPlaceHolder = false
                
                
                
            } catch {
                print("Veriler alınamadı: \(error.localizedDescription)")
                isPlaceHolder = false
            }
            
            companyName = ""
            companyAddress = ""
            companyPhone = ""
            
            workPNum = ""
            workName = ""
            workDesc = ""
            workPrice = ""
            workApprove = ""
            
            workRem = ""
            isExpiry = false
            recDateList = [Statement]()
            expDateList = [Statement]()
            workStartDate = .now
            workFinishDate = .now
            
            productList = [Product]()
            proPurchasedDate = .now
            
            proName = ""
            proQuantity = ""
            proPrice = ""
            proSuggestion = ""
            workPNum = ""
            workName = ""
        }
        
        
    }
    
    
    func createStatement(date: Date, price: Double) -> Statement {
        return Statement(date: date, price: price)
    }
    
    // Adds Data to Core Data.
    func create() {
        
        isPlaceHolder = true
        
        var recList: [[String: Any]] = []
        for rec in [Statement]() {
            recList.append([
                "date": rec.date,
                "price": rec.price
            ])
        }
        
        var expList: [[String: Any]] = []
        for rec in [Statement]() {
            expList.append([
                "date": rec.date,
                "price": rec.price
            ])
        }
        
        var proList: [[String: Any]] = []
        for pro in [Product]() {
            proList.append([
                "name": pro.name,
                "quantity": pro.quantity,
                "price": pro.price,
                "suggestion": pro.suggestion,
                "purchased": pro.purchased,
                "isBought": pro.isBought,
            ])
        }
        
        let price = workPrice.toDouble()
        
        db.collection("Company").document(workPNum).setData([
            "name": companyName,
            "address": companyAddress,
            "phone": companyPhone,
            "work": [
                "id": workPNum,
                "name": workName,
                "desc": workDesc,
                "price": price,
                "approve": workApprove,
                "accept": [
                    "remMoney": price,
                    "isExpiry": false,
                    "recList": recList,
                    "expList": expList,
                    "startDate": Date.now,
                    "finishDate": Date.now
                ],
                "product": proList
            ]
        ])
        
        fetchData()
    }
    
    //Update Data to Core Data.
    func update() {
        
        isPlaceHolder = true
        
        var recList: [[String: Any]] = []
        for rec in recDateList {
            recList.append([
                "date": rec.date,
                "price": rec.price
            ])
        }
        
        var expList: [[String: Any]] = []
        for rec in expDateList {
            expList.append([
                "name": rec.date,
                "price": rec.price
            ])
        }
        
        var proList: [[String: Any]] = []
        for pro in productList {
            proList.append([
                "name": pro.name,
                "quantity": pro.quantity,
                "price": pro.price,
                "suggestion": pro.suggestion,
                "purchased": pro.purchased,
                "isBought": pro.isBought,
            ])
        }
        
        let price = workPrice.toDouble()
        let rem = workRem.toDouble()
        
        db.collection("Company").document(workPNum).updateData([
            "name": companyName,
            "address": companyAddress,
            "phone": companyPhone,
            "work": [
                "id": workPNum,
                "name": workName,
                "desc": workDesc,
                "price": price,
                "approve": workApprove,
                "accept": [
                    "remMoney": rem,
                    "isExpiry": isExpiry,
                    "recList": recList,
                    "expList":  expList,
                    "startDate": workStartDate,
                    "finishDate": workFinishDate
                ],
                "product": proList
            ]
        ])
        
        fetchData()
    }
    
    // Delete Data to Core Data.
    func delete(_ company: Company) {
        
        fetchData()
    }
    
    
}

