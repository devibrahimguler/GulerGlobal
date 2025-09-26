//
//  FirebaseDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import Foundation
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
                
                try await withThrowingTaskGroup(of: Company?.self) { group in
                    for document in snapshot.documents {
                        group.addTask { try await self.parseCompany(from: document) }
                    }
                    
                    for try await company in group {
                        if let company = company {
                            companyList.append(company)
                        }
                    }
                }
                
                completion(.success(companyList))
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func parseCompany(from document: DocumentSnapshot) async throws -> Company? {
        guard let data = document.data() else { return nil }
        
        guard
            let id = data["id"] as? String,
            let companyName = data["companyName"] as? String,
            let companyAddress = data["companyAddress"] as? String,
            let contactNumber = data["contactNumber"] as? String,
            let partnerRoleRawValue = data["partnerRole"] as? String
        else { return nil }
        let partnerRole = PartnerRole(rawValue: partnerRoleRawValue) ?? .none
        let workList = try await fetchWorkList(for: id)
        
        return Company(id: id, companyName: companyName, companyAddress: companyAddress, contactNumber: contactNumber, partnerRole: partnerRole, workList: workList)
    }

    private func fetchWorkList(for companyId: String) async throws -> [Work] {
        let snapshot = try await database.collection("Companies").document(companyId).collection("WorkList").getDocuments()
        var workList: [Work] = []
        
        try await withThrowingTaskGroup(of: Work?.self) { group in
            for document in snapshot.documents {
                group.addTask { try await self.parseWork(from: document, companyId: companyId) }
            }
            
            for try await work in group {
                if let work = work {
                    workList.append(work)
                }
            }
        }
        
        return workList
    }

    private func parseWork(from document: DocumentSnapshot, companyId: String) async throws -> Work? {
        guard let data = document.data() else { return nil }
        
        guard
            let workId = data["id"] as? String,
            let workName = data["workName"] as? String,
            let workDescription = data["workDescription"] as? String,
            let totalCost = data["totalCost"] as? Double,
            let approveRawValue = data["approve"] as? String,
            let remainingBalance = data["remainingBalance"] as? Double,
            let startDate = (data["startDate"] as? Timestamp)?.dateValue(),
            let endDate = (data["endDate"] as? Timestamp)?.dateValue()
        else { return nil }
        
        let approve = ApprovalStatus(rawValue: approveRawValue) ?? .none
        async let productList = fetchProductList(for: companyId, workId: workId)
        async let statementList = fetchStatementList(for: companyId, workId: workId)
        
        return Work(id: workId, workName: workName, workDescription: workDescription, totalCost: totalCost, approve: approve, remainingBalance: remainingBalance, statements: try await statementList, startDate: startDate, endDate: endDate, productList: try await productList)
    }

    private func fetchProductList(for companyId: String, workId: String) async throws -> [Product] {
        let snapshot = try await database.collection("Companies").document(companyId)
            .collection("WorkList").document(workId).collection("ProductList").getDocuments()
        return snapshot.documents.compactMap { parseProduct(from: $0) }
    }

    private func parseProduct(from document: DocumentSnapshot) -> Product? {
        guard let data = document.data() else { return nil }
        
        return Product(
            id: data["id"] as? String ?? "",
            productName: data["productName"] as? String ?? "",
            quantity: data["quantity"] as? Int ?? 0,
            unitPrice: data["unitPrice"] as? Double ?? 0.0,
            supplier: data["supplier"] as? String ?? "",
            purchased: (data["purchased"] as? Timestamp)?.dateValue() ?? Date(),
            isBought: data["isBought"] as? Bool ?? false
        )
    }

    private func fetchStatementList(for companyId: String, workId: String) async throws -> [Statement] {
        let snapshot = try await database.collection("Companies").document(companyId)
            .collection("WorkList").document(workId).collection("StatementList").getDocuments()
        return snapshot.documents.compactMap { parseStatement(from: $0) }
    }

    private func parseStatement(from document: DocumentSnapshot) -> Statement? {
        guard let data = document.data() else { return nil }
        
        return Statement(
            id: data["id"] as? String ?? "",
            amount: data["amount"] as? Double ?? 0.0,
            date: (data["date"] as? Timestamp)?.dateValue() ?? Date(),
            status: StatementStatus(rawValue: data["status"] as? String ?? "") ?? .none
        )
    }

    // Cast a Statement
    private func castStatement(_ statement: Statement) -> [String: Any] {
        return [
            "id": statement.id,
            "amount": statement.amount,
            "date": statement.date,
            "status": statement.status.rawValue
        ]
    }
    
    // Cast a Product
    private func castProduct(_ product: Product) -> [String: Any] {
        return [
            "id": product.id,
            "productName": product.productName,
            "quantity": product.quantity,
            "unitPrice": product.unitPrice,
            "supplier": product.supplier,
            "purchased": product.purchased,
            "isBought": product.isBought
        ]
    }
    
    // Cast a Work
    private func castWork(_ work: Work) -> [String: Any] {
        return [
            "id": work.id,
            "workName": work.workName,
            "workDescription": work.workDescription,
            "totalCost": work.totalCost,
            "approve": work.approve.rawValue,
            "remainingBalance": work.remainingBalance,
            "startDate": work.startDate,
            "endDate": work.endDate
        ]
    }
    
    // Cast a Company
    private func castCompany(_ company: Company) -> [String: Any] {
        return [
            "id": company.id,
            "companyName": company.companyName,
            "companyAddress": company.companyAddress,
            "contactNumber": company.contactNumber,
            "partnerRole": company.partnerRole.rawValue,
        ]
    }
    
    // Create a Company
    func saveCompany(_ company: Company) {
        Task {
            let data = castCompany(company)
            try await database.collection("Companies").document(company.id).setData(data)
        }
    }

    // Update a Company
    func updateCompany(_ companyId: String, updateArea: [String: Any]) {
        Task {
            try await database.collection("Companies").document(companyId).updateData(updateArea)
        }
    }
    
    // Delete a Company
    func deleteCompany(_ companyId: String) {
        Task {
            try await database.collection("Companies").document(companyId).delete()
        }
    }

    // Create a Work
    func saveWork(_ companyId: String, _ work: Work) {
        Task {
            let data = castWork(work)
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(work.id).setData(data)
        }
    }

    // Update a Work
    func updateWork(_ companyId: String, _ workId: String, updateArea: [String: Any]) {
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId).updateData(updateArea)
        }
    }

    // Delete a Work
    func deleteWork(_ companyId: String, _ workId: String) {
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId).delete()
        }
    }

    // Create a Product
    func saveProduct(_ companyId: String, _ workId: String, _ product: Product) {
        Task {
            let data = castProduct(product)
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId)
                .collection("ProductList").document(product.id).setData(data)
        }
    }

    // Update a Product
    func updateProduct(_ companyId: String, _ workId: String, _ productId: String, updateArea: [String: Any]) {
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId)
                .collection("ProductList").document(productId).updateData(updateArea)
        }
    }

    // Delete a Product
    func deleteProduct(_ companyId: String, _ workId: String, _ productId: String) {
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId)
                .collection("ProductList").document(productId).delete()
        }
    }

    // Create a Statement
    func saveStatement(_ companyId: String, _ workId: String, _ statement: Statement) {
        Task {
            let data = castStatement(statement)
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId)
                .collection("StatementList").document(statement.id).setData(data)
        }
    }

    // Update a Statement
    func updateStatement(_ companyId: String, _ workId: String, _ statementId: String, updateArea: [String: Any]) {
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId)
                .collection("StatementList").document(statementId).updateData(updateArea)
        }
    }

    // Delete a Statement
    func deleteStatement(_ companyId: String, _ workId: String, _ statementId: String) {
        Task {
            try await database.collection("Companies").document(companyId)
                .collection("WorkList").document(workId)
                .collection("StatementList").document(statementId).delete()
        }
    }
}
