//
//  FirebaseDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import FirebaseFirestore

final class FirebaseDataModel: ObservableObject {
    
    private let db: Firestore = Firestore.firestore()
    
    // Get companies data from Database.
    @MainActor
    func fetchCompaniesData(complation: @escaping (Result<[Company], Error>) -> Void) {
        Task {
            do {
                let docRef = self.db.collection("Company")
                var worksList: [String] = []
                var companiesList: [Company] = []
                let companies = try await docRef.getDocuments()
                
                for company in companies.documents {
                    
                    if let getWorks = company.data()["works"] as? [String]  {
                        
                        for work in getWorks {
                            worksList.append(work)
                        }
                        
                        let newCompany = Company(
                            id: company.data()["id"] as? String ?? "",
                            name: company.data()["name"] as? String ?? "",
                            address: company.data()["address"] as? String ?? "",
                            phone: company.data()["phone"] as? String ?? "",
                            works: worksList)
                        
                        companiesList.append(newCompany)
                    }
                }
                
                complation(.success(companiesList))
                
            } catch {
                complation(.failure(error))
            }
        }
    }
    
    // Get works data from Database.
    @MainActor
    func fetchWorksData(complation: @escaping (Result<[Work], Error>) -> Void) {
        Task {
            do {
                let docRef = db.collection("Works")
                var workList: [Work] = []
                let works = try await docRef.getDocuments()
                
                for work in works.documents {
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
                        for pro in work["products"] as? [[String: Any]] ?? [] {
                            let name = pro["name"] as? String ?? ""
                            let quantity = pro["quantity"] as? Int32 ?? 0
                            let price = pro["price"] as? Double ?? 0
                            let suggestion = pro["suggestion"] as? String ?? ""
                            let purchased = pro["purchased"] as? Timestamp ?? .init(date: .now)
                            let isBought = pro["isBought"] as? Bool ?? false
                            proList.append(Product(name: name, quantity: quantity, price: price, suggestion: suggestion, purchased: purchased.dateValue(), isBought: isBought))
                        }
                        let start = accept["start"] as? Timestamp ?? .init(date: .now)
                        let finished = accept["finished"] as? Timestamp ?? .init(date: .now)
                        
                        let newWork = Work(
                            id: work["id"] as? String ?? "",
                            companyId: work["companyId"] as? String ?? "",
                            name: work["name"] as? String ?? "",
                            desc: work["desc"] as? String ?? "",
                            price: work["price"] as? Double ?? 0,
                            approve: work["approve"] as? String ?? "",
                            accept: Accept(
                                remMoney: accept["remMoney"] as? Double ?? 0,
                                recList: recList,
                                expList: expList,
                                start: start.dateValue(),
                                finished: finished.dateValue()),
                            products: proList)
                        
                        workList.append(newWork)
                    }
                }
                
                complation(.success(workList))
                
            } catch {
                complation(.failure(error))
            }
        }
        
        
    }
    
    // Add Data to Database.
    func create(company: Company, work: Work) -> Bool {
        
        db.collection("Company").document(company.id).setData([
            "id": company.id,
            "name": company.name,
            "address": company.address,
            "phone": company.phone,
            "works": company.works
        ])
        
        db.collection("Works").document(work.id).setData([
            "id": work.id,
            "companyId": company.id,
            "name": work.name,
            "desc": work.desc,
            "price": work.price,
            "approve": work.approve,
            "accept": [
                "remMoney": work.price,
                "isExpiry": false,
                "recList": [],
                "expList": [],
                "start": Date.now,
                "finished": Date.now
            ],
            "products": []
        ])
        
        
        return false
    }
    
    // Company update Data to Database.
    func companyUpdate(company: Company) -> Bool {
        
        db.collection("Company").document(company.id).setData([
            "id": company.id,
            "name": company.name,
            "address": company.address,
            "phone": company.phone,
            "works": company.works
        ])
        
        return false
    }
    
    // Work update Data to Database.
    func workUpdate(work: Work) -> Bool {
        
        var newRecList: [[String: Any]] = []
        for rec in work.accept.recList {
            newRecList.append([
                "date": rec.date,
                "price": rec.price
            ])
        }
        
        var newExpList: [[String: Any]] = []
        for exp in work.accept.expList {
            newExpList.append([
                "date": exp.date,
                "price": exp.price
            ])
        }
        
        var newProList: [[String: Any]] = []
        for pro in work.products {
            newProList.append([
                "name": pro.name,
                "quantity": pro.quantity,
                "price": pro.price,
                "suggestion": pro.suggestion,
                "purchased": pro.purchased,
                "isBought": pro.isBought,
            ])
        }
        
        db.collection("Works").document(work.id).setData([
            "id": work.id,
            "companyId": work.companyId,
            "name": work.name,
            "desc": work.desc,
            "price": work.price,
            "approve": work.approve,
            "accept": [
                "remMoney": work.accept.remMoney,
                "recList": newRecList,
                "expList": newExpList,
                "start": work.accept.start,
                "finished": work.accept.finished
            ],
            "products": newProList
        ])
        
        return false
    }
    
    // Delete Data from Database.
    func delete(_ company: Company) {
        
        // fetchData()
    }
    
    
}

