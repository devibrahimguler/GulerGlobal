//
//  FirebaseDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import FirebaseFirestore

final class FirebaseDataModel: ObservableObject {
    
    private let db: Firestore = Firestore.firestore()

    
    @Published var companies: [Company] = []
    
    @Published var works: [Work] = []
    @Published var waitWorks: [Work] = []
    @Published var approveWorks: [Work] = []
    @Published var unapproveWorks: [Work] = []
    @Published var finishedWorks: [Work] = []
    
    @Published var takenProducts: [Work] = []
    
    @Published var totalPrice: Double = 0
    @Published var totalRemPrice: Double = 0
    @Published var isPlaceHolder: Bool = false
    
    @Published var companyName: String = ""
    @Published var companyAddress: String = ""
    @Published var companyPhone: String = ""
    
    @Published var workPNum: String = ""
    @Published var workName: String = ""
    @Published var workDesc: String = ""
    @Published var workPrice: String = ""
    @Published var workRec: String = ""
    @Published var workRem: String = ""
    @Published var workExp: String = ""
    @Published var workApprove: String = ""
    
    @Published var workStart: Date = .now
    @Published var workFinished: Date = .now
    
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
    
    
    @Published var isPickerShower: Bool = false
    
    @Published var isNewCompany: Bool = true
    @Published var isPNum: Bool = true
    
    @Published var isExpiry: Bool = false
    @Published var formTitle: FormTitle = .none
    
    
    
    func getLastPNum() -> String? {
        var intPnum = 0
        for work in works {
            if Int(work.id) ?? 0 > intPnum {
                intPnum = Int(work.id) ?? 0
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
        /*
         for i in companies {
             if !newCompanies.contains(where: {$0.name == i.name }) {
                 newCompanies.append(i)
             }
         }
         */
        return value == "" ? nil : newCompanies.filter({ $0.name.lowercased().hasPrefix(value.lowercased()) })
    }
    
    // Pulls data from Core Data.
    @MainActor
    func fetchData() {
        let docRef = db.collection("Company")
        waitWorks = []
        approveWorks = []
        unapproveWorks = []
        finishedWorks = []
        takenProducts = []
        
        totalPrice = 0
        totalRemPrice = 0
        
        isPlaceHolder = true
        
        Task {
            do {
                let companies = try await docRef.getDocuments()
                
                for company in companies.documents {
                    
                    if let getWorks = company.data()["work"] as? [[String: Any]]  {
                        var workList: [Work] = []
                        for work in getWorks {
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
                                    workId: work["workId"] as? String ?? "",
                                    name: work["name"] as? String ?? "",
                                    desc: work["desc"] as? String ?? "",
                                    price: work["price"] as? Double ?? 0,
                                    approve: work["approve"] as? String ?? "",
                                    accept: Accept(
                                        remMoney: accept["remMoney"] as? Double ?? 0,
                                        isExpiry: accept["isExpiry"] as? Bool ?? false,
                                        recList: recList,
                                        expList: expList,
                                        start: accept["start"] as? Date ?? .now,
                                        finished: accept["finished"] as? Date ?? .now),
                                    product: proList)
                                
                                workList.append(newWork)
                                
                                switch work["approve"] as? String ?? "" {
                                case "Wait":
                                    self.waitWorks.append(newWork)
                                case "Approve":
                                    self.approveWorks.append(newWork)
                                    self.totalRemPrice += accept["remMoney"] as? Double ?? 0
                                    self.totalPrice += work["price"] as? Double ?? 0
                                case "Unapprove":
                                    self.unapproveWorks.append(newWork)
                                case "Finished":
                                    self.finishedWorks.append(newWork)
                                default:
                                    print("Not found any information!")
                                }
                                
                                for p in productList {
                                    if !p.isBought {
                                        if !self.takenProducts.contains(where: { w in w == newWork}) {
                                            self.takenProducts.append(newWork)
                                        }
                                    }
                                }
                            }
                        }
                        
                        let newCompany = Company(
                            id: company.data()["id"] as? String ?? "",
                            name: company.data()["name"] as? String ?? "",
                            address: company.data()["address"] as? String ?? "",
                            phone: company.data()["phone"] as? String ?? "",
                            work: workList)
                        
                        
                        self.companies.append(newCompany)
                      
                    }
                }
                
                self.waitWorks = self.waitWorks.sorted(by: { $0.id > $1.id })
                self.approveWorks = self.approveWorks.sorted(by: { $0.id > $1.id })
                self.unapproveWorks = self.unapproveWorks.sorted(by: { $0.id > $1.id })
                self.finishedWorks = self.finishedWorks.sorted(by: { $0.id > $1.id })
                self.companies = self.companies.sorted(by: { $0.id > $1.id })
                
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
            recList = [Statement]()
            expList = [Statement]()
            workStart = .now
            workFinished = .now
            
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
    
    // Adds Data.
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
        
        // fetchData()
    }
    
    //Update Data.
    func update() {
        
        isPlaceHolder = true
        
        var newRecList: [[String: Any]] = []
        for rec in recList {
            newRecList.append([
                "date": rec.date,
                "price": rec.price
            ])
        }
        
        var newExpList: [[String: Any]] = []
        for rec in expList {
            newExpList.append([
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
                    "recList": newRecList,
                    "expList":  newExpList,
                    "start": workStart,
                    "finished": workFinished
                ],
                "product": proList
            ]
        ])
        
        // fetchData()
    }
    
    // Delete Data.
    func delete(_ company: Company) {
        
        // fetchData()
    }
    
    
}

