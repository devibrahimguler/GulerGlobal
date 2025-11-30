//
//  FirebaseDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import Foundation
import FirebaseFirestore

final class FirebaseDataModel: ObservableObject {
    let companyCollectionName: String = "Companies4"
    let workCollectionName: String = "Works"
    let companyProductCollectionName: String = "CompanyProducts"
    let workProductCollectionName: String = "WorkProducts"
    let statementCollectionName: String = "Statements"
    
    private let database: Firestore = Firestore.firestore()
    
    // Fetch company data from the database
    @MainActor
    func fetchCompanies(completion: @escaping (Result<[Company], Error>) -> Void) {
        Task {
            do {
                let snapshot = try await database
                    .collection(companyCollectionName)
                    .getDocuments()
                
                var companies: [Company] = []
                
                try await withThrowingTaskGroup(of: Company?.self) { group in
                    for document in snapshot.documents {
                        group.addTask { try document.data(as: Company.self) }
                    }
                    
                    for try await company in group {
                        if let company = company {
                            companies.append(company)
                        }
                    }
                }
                
                completion(.success(companies))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Fetch work data from the database
    @MainActor
    func fetchWorks(completion: @escaping (Result<[Work], Error>) -> Void) {
        Task {
            do {
                let snapshot = try await database
                    .collection(workCollectionName)
                    .getDocuments()
                
                var works: [Work] = []
                
                try await withThrowingTaskGroup(of: Work?.self) { group in
                    for document in snapshot.documents {
                        group.addTask { try document.data(as: Work.self) }
                    }
                    
                    for try await work in group {
                        if let work = work {
                            works.append(work)
                        }
                    }
                }
                
                completion(.success(works))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Fetch Company Product data from the database
    @MainActor
    func fetchCompanyProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        Task {
            do {
                let snapshot = try await database
                    .collection(companyProductCollectionName)
                    .getDocuments()
                
                var products: [Product] = []
                
                try await withThrowingTaskGroup(of: Product?.self) { group in
                    for document in snapshot.documents {
                        group.addTask { try document.data(as: Product.self) }
                    }
                    
                    for try await product in group {
                        if let product = product {
                            products.append(product)
                        }
                    }
                }
                
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Fetch Work Product data from the database
    @MainActor
    func fetchWorkProducts(completion: @escaping (Result<[WorkProduct], Error>) -> Void) {
        Task {
            do {
                let snapshot = try await database
                    .collection(workProductCollectionName)
                    .getDocuments()
                
                var products: [WorkProduct] = []
                
                try await withThrowingTaskGroup(of: WorkProduct?.self) { group in
                    for document in snapshot.documents {
                        group.addTask { try document.data(as: WorkProduct.self) }
                    }
                    
                    for try await product in group {
                        if let product = product {
                            products.append(product)
                        }
                    }
                }
                
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }
    }
     
    // Fetch Statement data from the database
    @MainActor
    func fetchStatements(completion: @escaping (Result<[Statement], Error>) -> Void) {
        Task {
            do {
                let snapshot = try await database
                    .collection(statementCollectionName)
                    .getDocuments()
                
                var statements: [Statement] = []
                
                try await withThrowingTaskGroup(of: Statement?.self) { group in
                    for document in snapshot.documents {
                        group.addTask { try document.data(as: Statement.self) }
                    }
                    
                    for try await statement in group {
                        if let statement = statement {
                            statements.append(statement)
                        }
                    }
                }
                
                completion(.success(statements))
            } catch {
                completion(.failure(error))
            }
        }
    }

    
    // Cast a Company
    private func castCompany(_ company: Company) -> [String: Any] {
        return [
            "id": company.id,
            "name": company.name,
            "address": company.address,
            "phone": company.phone,
            "status": company.status.rawValue
        ]
    }
    
    // Cast a Work
    private func castWork(_ work: Work) -> [String: Any] {
        return [
            "id": work.id,
            "companyId": work.companyId,
            "name": work.name,
            "description": work.description,
            "cost": work.cost,
            "status": work.status.rawValue,
            "startDate": work.startDate,
            "endDate": work.endDate,
            "products": work.products ?? ""
        ]
    }
    
    // Cast a Company Product
    private func castCompanyProduct(_ product: Product) -> [String: Any] {
        return [
            "id": product.id,
            "companyId": product.companyId,
            "name": product.name,
            "quantity": product.quantity,
            "price": product.price,
            "date": product.date,
            "oldPrices": product.oldPrices
        ]
    }
    
    // Cast a Work Product
    private func castWorkProduct(_ product: WorkProduct) -> [String: Any] {
        return [
            "id": product.id,
            "workId": product.workId,
            "productId": product.productId,
            "quantity": product.quantity,
            "date": product.date
        ]
    }
    
    // Cast a Statement
    private func castStatement(_ statement: Statement) -> [String: Any] {
        return [
            "id": statement.id,
            "companyId": statement.companyId,
            "amount": statement.amount,
            "date": statement.date,
            "status": statement.status
        ]
    }
    
    // Create a Company
    func saveCompany(_ company: Company) {
        Task {
            let data = castCompany(company)
            try await database
                .collection(companyCollectionName).document(company.id)
                .setData(data)
        }
    }

    // Update a Company
    func updateCompany(_ companyId: String, updateArea: [String: Any]) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .updateData(updateArea)
        }
    }
    
    // Delete a Company
    func deleteCompany(_ companyId: String) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .delete()
        }
    }

    // Create a Work
    func saveWork(_ work: Work) {
        Task {
            let data = castWork(work)
            try await database
                .collection(workCollectionName).document(work.id)
                .setData(data)
        }
    }

    // Update a Work
    func updateWork(_ workId: String, updateArea: [String: Any]) {
        Task {
            try await database
                .collection(workCollectionName).document(workId)
                .updateData(updateArea)
        }
    }

    // Delete a Work
    func deleteWork(_ workId: String) {
        Task {
            try await database
                .collection(workCollectionName).document(workId)
                .delete()
        }
    }

    // Create a Company Product
    func saveCompanyProduct(_ product: Product) {
        Task {
            let data = castCompanyProduct(product)
            try await database
                .collection(companyProductCollectionName).document(product.id)
                .setData(data)
        }
    }

    // Update a Company Product
    func updateCompanyProduct(_ productId: String, updateArea: [String: Any]) {
        Task {
            try await database
                .collection(companyProductCollectionName).document(productId)
                .updateData(updateArea)
        }
    }

    // Delete a Company Product
    func deleteCompanyProduct(_ productId: String) {
        Task {
            try await database
                .collection(companyProductCollectionName).document(productId)
                .delete()
        }
    }
    
    // Create a Work Product
    func saveWorkProduct(_ product: WorkProduct) {
        Task {
            let data = castWorkProduct(product)
            try await database
                .collection(workProductCollectionName).document(product.id)
                .setData(data)
        }
    }

    // Update a Work Product
    func updateWorkProduct(_ productId: String, updateArea: [String: Any]) {
        Task {
            try await database
                .collection(workProductCollectionName).document(productId)
                .updateData(updateArea)
        }
    }

    // Delete a Work Product
    func deleteWorkProduct(_ productId: String) {
        Task {
            try await database
                .collection(workProductCollectionName).document(productId)
                .delete()
        }
    }

    // Create a Statement
    func saveStatement(_ statement: Statement) {
        Task {
            let data = castStatement(statement)
            try await database
                .collection(statementCollectionName).document(statement.id)
                .setData(data)
        }
    }

    // Update a Statement
    func updateStatement(_ statementId: String, updateArea: [String: Any]) {
        Task {
            try await database
                .collection(statementCollectionName).document(statementId)
                .updateData(updateArea)
        }
    }

    // Delete a Statement
    func deleteStatement(_ statementId: String) {
        Task {
            try await database
                .collection(statementCollectionName).document(statementId)
                .delete()
        }
    }

}
