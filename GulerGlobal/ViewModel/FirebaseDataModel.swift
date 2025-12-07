//
//  FirebaseDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import Foundation
import FirebaseFirestore

final class FirebaseDataModel: ObservableObject {
    let companyCollectionName: String = "Companies5"
    let workCollectionName: String = "Works5"
    let companyProductCollectionName: String = "CompanyProducts5"
    let workProductCollectionName: String = "WorkProducts5"
    let statementCollectionName: String = "Statements5"
    
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
    func fetchCompanyProducts(completion: @escaping (Result<[CompanyProduct], Error>) -> Void) {
        Task {
            do {
                let snapshot = try await database
                    .collection(companyProductCollectionName)
                    .getDocuments()
                
                var products: [CompanyProduct] = []
                
                try await withThrowingTaskGroup(of: CompanyProduct?.self) { group in
                    for document in snapshot.documents {
                        group.addTask { try document.data(as: CompanyProduct.self) }
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
    
    // Create a Company
    func saveCompany(_ company: Company) async throws {
        try database
            .collection(companyCollectionName).document(company.id)
            .setData(from: company)
    }
    
    // Update a Company
    func updateCompany(_ companyId: String, updateArea: [String: Any]) async throws {
        try await database
            .collection(companyCollectionName).document(companyId)
            .updateData(updateArea)
    }
    
    // Delete a Company
    func deleteCompany(_ companyId: String) async throws {
        try await database
            .collection(companyCollectionName).document(companyId)
            .delete()
    }
    
    // Create a Work
    func saveWork(_ work: Work) async throws {
        Task {
            try database
                .collection(workCollectionName).document(work.id)
                .setData(from: work)
        }
    }
    
    // Update a Work
    func updateWork(_ workId: String, updateArea: [String: Any]) async throws {
        Task {
            try await database
                .collection(workCollectionName).document(workId)
                .updateData(updateArea)
        }
    }
    
    // Delete a Work
    func deleteWork(_ workId: String) async throws {
        Task {
            try await database
                .collection(workCollectionName).document(workId)
                .delete()
        }
    }
    
    // Delete Multiple Works
    func deleteMultipleWork(_ workIds: [String], completion: @escaping ((any Error)?) -> Void) {
        let batch = database.batch()
        for id in workIds {
            let docRef = database.collection(workCollectionName).document(id)
            batch.deleteDocument(docRef)
        }
        
        batch.commit(completion: completion)
    }
    
    // Create a Company Product
    func saveCompanyProduct(_ product: CompanyProduct) async throws {
        Task {
            try database
                .collection(companyProductCollectionName).document(product.id)
                .setData(from: product)
        }
    }
    
    // Update a Company Product
    func updateCompanyProduct(_ productId: String, updateArea: [String: Any]) async throws {
        Task {
            try await database
                .collection(companyProductCollectionName).document(productId)
                .updateData(updateArea)
        }
    }
    
    // Delete a Company Product
    func deleteCompanyProduct(_ productId: String) async throws {
        Task {
            try await database
                .collection(companyProductCollectionName).document(productId)
                .delete()
        }
    }
    
    // Delete Multiple Company Products
    func deleteMultipleCompanyProduct(_ productIds: [String], completion: @escaping ((any Error)?) -> Void) {
        let batch = database.batch()
        for id in productIds {
            let docRef = database.collection(companyProductCollectionName).document(id)
            batch.deleteDocument(docRef)
        }
        
        batch.commit(completion: completion)
    }
    
    // Create a Work Product
    func saveWorkProduct(_ product: WorkProduct) async throws {
        Task {
            try database
                .collection(workProductCollectionName).document(product.id)
                .setData(from: product)
        }
    }
    
    // Update a Work Product
    func updateWorkProduct(_ productId: String, updateArea: [String: Any]) async throws {
        Task {
            try await database
                .collection(workProductCollectionName).document(productId)
                .updateData(updateArea)
        }
    }
    
    // Delete a Work Product
    func deleteWorkProduct(_ productId: String) async throws {
        Task {
            try await database
                .collection(workProductCollectionName).document(productId)
                .delete()
        }
    }
    
    // Delete Multiple Work Products
    func deleteMultipleWorkProduct(_ productIds: [String], completion: @escaping ((any Error)?) -> Void) {
        let batch = database.batch()
        for id in productIds {
            let docRef = database.collection(workProductCollectionName).document(id)
            batch.deleteDocument(docRef)
        }
        
        batch.commit(completion: completion)
    }
    
    // Create a Statement
    func saveStatement(_ statement: Statement) async throws {
        Task {
            try database
                .collection(statementCollectionName).document(statement.id)
                .setData(from: statement)
        }
    }
    
    // Update a Statement
    func updateStatement(_ statementId: String, updateArea: [String: Any]) async throws {
        Task {
            try await database
                .collection(statementCollectionName).document(statementId)
                .updateData(updateArea)
        }
    }
    
    // Delete a Statement
    func deleteStatement(_ statementId: String) async throws {
        Task {
            try await database
                .collection(statementCollectionName).document(statementId)
                .delete()
        }
    }
    
    // Delete Multiple Statements
    func deleteMultipleStatement(_ statementIds: [String], completion: @escaping ((any Error)?) -> Void) {
        let batch = database.batch()
        for id in statementIds {
            let docRef = database.collection(statementCollectionName).document(id)
            batch.deleteDocument(docRef)
        }
        
        batch.commit(completion: completion)
    }
    
}
