//
//  FirebaseDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import FirebaseFirestore

final class FirebaseDataModel: ObservableObject {
    private let database: Firestore = Firestore.firestore()
    
    // Fetch company data from the database
    @MainActor
    func fetchCompanies(completion: @escaping (Result<[Company], Error>) -> Void) {
        Task {
            do {
                let snapshot = try await database.collection("Companies").getDocuments()
                var companyList: [Company] = []
                
                for document in snapshot.documents {
                    guard let company = try await parseCompany(from: document) else { continue }
                    companyList.append(company)
                }
                
                completion(.success(companyList))
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func parseCompany(from document: DocumentSnapshot) async throws -> Company? {
        let data = document.data()
        
        guard
            let id = data?["id"] as? String,
            let companyName = data?["companyName"] as? String,
            let companyAddress = data?["companyAddress"] as? String,
            let contactNumber = data?["contactNumber"] as? String
        else { return nil }
        
        let workList = try await fetchWorkList(for: id)
        
        return Company(id: id, companyName: companyName, companyAddress: companyAddress, contactNumber: contactNumber, workList: workList)
    }

    private func fetchWorkList(for companyId: String) async throws -> [Work] {
        let snapshot = try await database.collection("Companies").document(companyId).collection("WorkList").getDocuments()
        var workList: [Work] = []
        
        for document in snapshot.documents {
            guard let work = try await parseWork(from: document, companyId: companyId) else { continue }
            workList.append(work)
        }
        
        return workList
    }

    private func parseWork(from document: DocumentSnapshot, companyId: String) async throws -> Work? {
        let data = document.data()
        
        guard
            let workId = data?["id"] as? String,
            let workName = data?["workName"] as? String,
            let workDescription = data?["workDescription"] as? String,
            let totalCost = data?["totalCost"] as? Double,
            let approveRawValue = data?["approve"] as? String,
            let remainingBalance = data?["remainingBalance"] as? Double,
            let startDate = (data?["startDate"] as? Timestamp)?.dateValue(),
            let endDate = (data?["endDate"] as? Timestamp)?.dateValue()
        else { return nil }
        
        let approve = ApprovalStatus(rawValue: approveRawValue) ?? .none
        let productList = try await fetchProductList(for: companyId, workId: workId)
        let statementList = try await fetchStatementList(for: companyId, workId: workId)
        
        return Work(id: workId, workName: workName, workDescription: workDescription, totalCost: totalCost, approve: approve, remainingBalance: remainingBalance, statements: statementList, startDate: startDate, endDate: endDate, productList: productList)
    }

    private func fetchProductList(for companyId: String, workId: String) async throws -> [Product] {
        let snapshot = try await database.collection("Companies").document(companyId).collection("WorkList").document(workId).collection("ProductList").getDocuments()
        var productList: [Product] = []
        
        for document in snapshot.documents {
            guard let product = parseProduct(from: document) else { continue }
            productList.append(product)
        }
        
        return productList
    }

    private func parseProduct(from document: DocumentSnapshot) -> Product? {
        let data = document.data()
        
        guard
            let productId = data?["id"] as? String,
            let productName = data?["productName"] as? String,
            let quantity = data?["quantity"] as? Int,
            let unitPrice = data?["unitPrice"] as? Double,
            let suggestion = data?["suggestion"] as? String,
            let purchased = (data?["purchased"] as? Timestamp)?.dateValue(),
            let isBought = data?["isBought"] as? Bool
        else { return nil }
        
        return Product(id: productId, productName: productName, quantity: quantity, unitPrice: unitPrice, suggestion: suggestion, purchased: purchased, isBought: isBought)
    }

    private func fetchStatementList(for companyId: String, workId: String) async throws -> [Statement] {
        let snapshot = try await database.collection("Companies").document(companyId).collection("WorkList").document(workId).collection("StatementList").getDocuments()
        var statementList: [Statement] = []
        
        for document in snapshot.documents {
            guard let statement = parseStatement(from: document) else { continue }
            statementList.append(statement)
        }
        
        return statementList
    }

    private func parseStatement(from document: DocumentSnapshot) -> Statement? {
        let data = document.data()
        
        guard
            let statementId = data?["id"] as? String,
            let amount = data?["amount"] as? Double,
            let date = (data?["date"] as? Timestamp)?.dateValue(),
            let statusRawValue = data?["status"] as? String
        else { return nil }
        
        let status = StatementStatus(rawValue: statusRawValue) ?? .none
        
        return Statement(id: statementId, amount: amount, date: date, status: status)
    }

    
    // Cast a Statement
    private func castStatement(_ statement: Statement) -> [String: Any] {
        let data: [String: Any] = [
            "id": statement.id,
            "amount": statement.amount,
            "date": statement.date,
            "status": statement.status.rawValue
        ]
        
        return data
    }
    
    // Cast a Product
    private func castProduct(_ product: Product) -> [String: Any] {
        let data: [String: Any] = [
            "id": product.id,
            "productName": product.productName,
            "quantity": product.quantity,
            "unitPrice": product.unitPrice,
            "suggestion": product.suggestion,
            "purchased": product.purchased,
            "isBought": product.isBought
        ]
        
        return data
    }
    
    // Cast a Work
    private func castWork(_ work: Work) -> [String: Any] {
        let data: [String: Any] = [
            "id": work.id,
            "workName": work.workName,
            "workDescription": work.workDescription,
            "totalCost": work.totalCost,
            "approve": work.approve.rawValue,
            "remainingBalance": work.remainingBalance,
            "startDate": work.startDate,
            "endDate": work.endDate
        ]
        
        return data
    }
    
    // Cast a Company
    private func castCompany(_ company: Company) -> [String: Any] {
        let data: [String: Any] = [
            "id": company.id,
            "companyName": company.companyName,
            "companyAddress": company.companyAddress,
            "contactNumber": company.contactNumber,
        ]
        
        return data
    }
    
    // Create a Company
    func saveCompany(_ company: Company) -> Bool{
        let data = castCompany(company)
        Task {
            try await database.collection("Companies").document(company.id).setData(data)
            return false
        }
        return true
    }
    // Update a Company
    func updateCompany(_ companyId: String, updateArea: [String: Any]) -> Bool{
        Task {
            try await database.collection("Companies").document(companyId).updateData(updateArea)
            return false
        }
        return true
    }
    // Create a Work
    func saveWork(_ companyId: String, _ work: Work) -> Bool{
        let data = castWork(work)
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(work.id).setData(data)
            return false
        }
        return true
    }
    // Update a Work
    func updateWork(_ companyId: String, _ workId: String, updateArea: [String: Any]) -> Bool{
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId).updateData(updateArea)
            return false
        }
        return true
    }
    // delete a Work
    func deleteWork(_ companyId: String, _ workId: String) -> Bool{
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId).delete()
            return false
        }
        return true
    }
    // Create a Product
    func saveProduct(_ companyId: String, _ workId: String, _ product: Product) -> Bool{
        let data = castProduct(product)
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId)
                .collection("ProductList").document(product.id).setData(data)
            return false
        }
        return true
    }
    // Update a Product
    func updateProduct(_ companyId: String, _ workId: String, _ productId: String, updateArea: [String: Any]) -> Bool{
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId)
                .collection("ProductList").document(productId).updateData(updateArea)
            return false
        }
        return true
    }
    // Delete a Product
    func deleteProduct(_ companyId: String, _ workId: String, _ productId: String) -> Bool{
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId)
                .collection("ProductList").document(productId).delete()
            return false
        }
        return true
    }
    
    // Create a Statement
    func saveStatement(_ companyId: String, _ workId: String, _ statement: Statement) -> Bool{
        let data = castStatement(statement)
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId)
                .collection("StatementList").document(statement.id).setData(data)
            return false
        }
        return true
    }
    // Update a Statement
    func updateStatement(_ companyId: String, _ workId: String, _ statementId: String, updateArea: [String: Any]) -> Bool{
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId)
                .collection("StatementList").document(statementId).updateData(updateArea)
            return false
        }
        return true
    }
    // Delete a Statement
    func deleteStatement(_ companyId: String, _ workId: String, _ statementId: String) -> Bool{
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId)
                .collection("StatementList").document(statementId).delete()
            return false
        }
        return true
    }
    
}


