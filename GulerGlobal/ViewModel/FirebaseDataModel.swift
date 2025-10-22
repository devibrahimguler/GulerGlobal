//
//  FirebaseDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import Foundation
import FirebaseFirestore

final class FirebaseDataModel: ObservableObject {
    let companyCollectionName: String = "Companies2"
    let workCollectionName: String = "WorkList"
    let productCollectionName: String = "ProductList"
    let statementCollectionName: String = "StatementList"
    let oldPricesCollectionName: String = "OldPricesList"
    
    private let database: Firestore = Firestore.firestore()
    
    // Fetch company data from the database
    @MainActor
    func fetchCompanies(completion: @escaping (Result<[Company], Error>) -> Void) {
        Task {
            do {
                let snapshot = try await database.collection(companyCollectionName).getDocuments()
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

    private func fetchWorkList(for companyId: String) async throws -> [Work] {
        let snapshot = try await database.collection(companyCollectionName).document(companyId).collection(workCollectionName).getDocuments()
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
    
    private func fetchProductCompany(for companyId: String) async throws -> [Product] {
        let snapshot = try await database
            .collection(companyCollectionName).document(companyId)
            .collection(productCollectionName)
            .getDocuments()
        
        var productList: [Product] = []
        
        try await withThrowingTaskGroup(of: Product?.self) { group in
            for document in snapshot.documents {
                group.addTask { try await self.parseProduct(from: document, companyId: companyId) }
            }
            
            for try await product in group {
                if let product = product {
                    productList.append(product)
                }
            }
        }
        
        return productList
    }
    
    private func fetchProductWork(workId: String, companyId: String) async throws -> [Product] {
        let snapshot = try await database
            .collection(companyCollectionName).document(companyId)
            .collection(workCollectionName).document(workId)
            .collection(productCollectionName)
            .getDocuments()
        
        return snapshot.documents.compactMap { parseProduct(from: $0) }
    }
    
    private func fetchStatementList(for companyId: String) async throws -> [Statement] {
        let snapshot = try await database
            .collection(companyCollectionName).document(companyId)
            .collection(statementCollectionName)
            .getDocuments()
        
        var statementList: [Statement] = []
        
        try await withThrowingTaskGroup(of: Statement?.self) { group in
            for document in snapshot.documents {
                group.addTask { try await self.parseStatement(from: document, companyId: companyId) }
            }
            
            for try await statement in group {
                if let statement = statement {
                    statementList.append(statement)
                }
            }
        }
        
        return statementList
    }
    
    private func fetchOldPrices(companyId: String, productId: String) async throws -> [OldPrice] {
        let snapshot = try await database
            .collection(companyCollectionName).document(companyId)
            .collection(productCollectionName).document(productId)
            .collection(oldPricesCollectionName)
            .getDocuments()
        
        return snapshot.documents.compactMap { parseOldPrice(from: $0) }
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
        let statementList = try await fetchStatementList(for: id)
        let productList = try await fetchProductCompany(for: id)
        
        let company = Company(
            id: id,
            companyName: companyName,
            companyAddress: companyAddress,
            contactNumber: contactNumber,
            partnerRole: partnerRole,
            workList: workList,
            statements: statementList,
            productList: productList
        )
        
        return company
    }
    
    private func parseWork(from document: DocumentSnapshot, companyId: String) async throws -> Work? {
        guard let data = document.data() else { return nil }
        
        guard
            let workId = data["id"] as? String,
            let workName = data["workName"] as? String,
            let workDescription = data["workDescription"] as? String,
            let remainingBalance = data["remainingBalance"] as? Double,
            let totalCost = data["totalCost"] as? Double,
            let approveRawValue = data["approve"] as? String,
            let startDate = (data["startDate"] as? Timestamp)?.dateValue(),
            let endDate = (data["endDate"] as? Timestamp)?.dateValue()
        else { return nil }
        
        let approve = ApprovalStatus(rawValue: approveRawValue) ?? .none
        let productList = try await fetchProductWork(workId: workId, companyId: companyId)
        
        let work = Work(
            id: workId,
            workName: workName,
            workDescription: workDescription,
            remainingBalance: remainingBalance,
            totalCost: totalCost,
            approve: approve,
            productList: productList,
            startDate: startDate,
            endDate: endDate
        )
        
        return work
    }

    private func parseProduct(from document: DocumentSnapshot, companyId: String) async throws -> Product? {
        guard let data = document.data() else { return nil }
        
        guard
            let id = data["id"] as? String,
            let supplierId = data["supplierId"] as? String,
            let supplier = data["supplier"] as? String,
            let productName = data["productName"] as? String,
            let quantity = data["quantity"] as? Double,
            let unitPrice = data["unitPrice"] as? Double,
            let purchased = (data["purchased"] as? Timestamp)?.dateValue()
        else { return nil }
        
        let oldPrices = try await fetchOldPrices(companyId: companyId, productId: id)
        
        let product = Product(
            id: id,
            supplierId: supplierId,
            supplier: supplier,
            productName: productName,
            quantity: quantity,
            unitPrice: unitPrice,
            oldPrices: oldPrices,
            purchased: purchased
        )
        
        return product
    }
    
    private func parseProduct(from document: DocumentSnapshot) -> Product? {
        guard let data = document.data() else { return nil }
        
        guard
            let id = data["id"] as? String,
            let supplierId = data["supplierId"] as? String,
            let supplier = data["supplier"] as? String,
            let productName = data["productName"] as? String,
            let quantity = data["quantity"] as? Double,
            let unitPrice = data["unitPrice"] as? Double,
            let purchased = (data["purchased"] as? Timestamp)?.dateValue()
        else { return nil }
        
        let oldPrices = [OldPrice]()
        
        let product = Product(
            id: id,
            supplierId: supplierId,
            supplier: supplier,
            productName: productName,
            quantity: quantity,
            unitPrice: unitPrice,
            oldPrices: oldPrices,
            purchased: purchased
        )
        
        return product
    }
    
    private func parseOldPrice(from document: DocumentSnapshot) -> OldPrice? {
        guard let data = document.data() else { return nil }
        
        guard
            let id = data["id"] as? String,
            let price = data["price"] as? Double,
            let date = (data["date"] as? Timestamp)?.dateValue()
        else { return nil }
        
        let oldPrice = OldPrice(
            id: id,
            price: price,
            date: date
        )
        
        return oldPrice
    }

    private func parseStatement(from document: DocumentSnapshot, companyId: String) async throws -> Statement? {
        guard let data = document.data() else { return nil }
        
        guard
            let statementId = data["id"] as? String,
            let statementAmount = data["amount"] as? Double,
            let statementDate = (data["date"] as? Timestamp)?.dateValue()
        else { return nil }
        
        let statementStatus = StatementStatus(rawValue: data["status"] as? String ?? "") ?? .none
        
        return Statement(id: statementId, amount: statementAmount, date: statementDate, status: statementStatus)
    }
    
    // Cast a OldPrice
    private func castOldPrice(_ oldPrice: OldPrice) -> [String: Any] {
        return [
            "id": oldPrice.id,
            "price": oldPrice.price,
            "date": oldPrice.date,
        ]
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
            "supplierId": product.supplierId,
            "supplier": product.supplier,
            "productName": product.productName,
            "quantity": product.quantity,
            "unitPrice": product.unitPrice,
            "purchased": product.purchased
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
            "partnerRole": company.partnerRole.rawValue
        ]
    }
    
    // Create a Company
    func saveCompany(_ company: Company) {
        Task {
            let data = castCompany(company)
            try await database.collection(companyCollectionName).document(company.id).setData(data)
        }
    }

    // Update a Company
    func updateCompany(_ companyId: String, updateArea: [String: Any]) {
        Task {
            try await database.collection(companyCollectionName).document(companyId).updateData(updateArea)
        }
    }
    
    // Delete a Company
    func deleteCompany(_ companyId: String) {
        Task {
            try await database.collection(companyCollectionName).document(companyId).delete()
        }
    }

    // Create a Work
    func saveWork(_ companyId: String, _ work: Work) {
        Task {
            let data = castWork(work)
            try await database.collection(companyCollectionName).document(companyId)
                .collection(workCollectionName).document(work.id).setData(data)
        }
    }

    // Update a Work
    func updateWork(_ companyId: String, _ workId: String, updateArea: [String: Any]) {
        Task {
            try await database.collection(companyCollectionName).document(companyId)
                .collection(workCollectionName).document(workId).updateData(updateArea)
        }
    }

    // Delete a Work
    func deleteWork(_ companyId: String, _ workId: String) {
        Task {
            try await database.collection(companyCollectionName).document(companyId)
                .collection(workCollectionName).document(workId).delete()
        }
    }

    // Create a Product
    func saveProduct(_ companyId: String, _ workId: String?, _ product: Product) {
        Task {
            let data = castProduct(product)
            if let workId = workId {
                try await database
                    .collection(companyCollectionName).document(companyId)
                    .collection(workCollectionName).document(workId)
                    .collection(productCollectionName).document(product.id)
                    .setData(data)
            } else {
                try await database
                    .collection(companyCollectionName).document(companyId)
                    .collection(productCollectionName).document(product.id)
                    .setData(data)
            }
        }
    }

    // Update a Product
    func updateProduct(_ companyId: String, _ workId: String?, _ productId: String, updateArea: [String: Any]) {
        Task {
            if let workId = workId {
                try await database
                    .collection(companyCollectionName).document(companyId)
                    .collection(workCollectionName).document(workId)
                    .collection(productCollectionName).document(productId)
                    .updateData(updateArea)
            } else {
                try await database
                    .collection(companyCollectionName).document(companyId)
                    .collection(productCollectionName).document(productId)
                    .updateData(updateArea)
            }
        }
    }

    // Delete a Product
    func deleteProduct(_ companyId: String, _ workId: String?, _ productId: String) {
        Task {
            if let workId = workId {
                try await database
                    .collection(companyCollectionName).document(companyId)
                    .collection(workCollectionName).document(workId)
                    .collection(productCollectionName).document(productId)
                    .delete()
            } else {
                try await database
                    .collection(companyCollectionName).document(companyId)
                    .collection(productCollectionName).document(productId)
                    .delete()
            }
            
        }
    }

    // Create a Statement
    func saveStatement(_ companyId: String, _ statement: Statement) {
        Task {
            let data = castStatement(statement)
            try await database.collection(companyCollectionName).document(companyId)
                .collection(statementCollectionName).document(statement.id).setData(data)
        }
    }

    // Update a Statement
    func updateStatement(_ companyId: String, _ statementId: String, updateArea: [String: Any]) {
        Task {
            try await database.collection(companyCollectionName).document(companyId)
                .collection(statementCollectionName).document(statementId).updateData(updateArea)
        }
    }

    // Delete a Statement
    func deleteStatement(_ companyId: String, _ statementId: String) {
        Task {
            try await database.collection(companyCollectionName).document(companyId)
                .collection(statementCollectionName).document(statementId).delete()
        }
    }
    
    // Create a OldPrice
    func saveOldPrice(_ companyId: String,  _ productId: String,_ oldPrice: OldPrice) {
        Task {
            let data = castOldPrice(oldPrice)
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(productCollectionName).document(productId)
                .collection(oldPricesCollectionName).document(oldPrice.id)
                .setData(data)
        }
    }

    // Update a OldPrice
    func updateOldPrice(_ companyId: String, _ productId: String, _ oldPriceId: String, updateArea: [String: Any]) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(productCollectionName).document(productId)
                .collection(oldPricesCollectionName).document(oldPriceId)
                .updateData(updateArea)
        }
    }

    // Delete a OldPrice
    func deleteOldPrice(_ companyId: String, _ productId: String, _ oldPriceId: String) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(productCollectionName).document(productId)
                .collection(oldPricesCollectionName).document(oldPriceId)
                .delete()
        }
    }
}
