//
//  CompanyProductDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim on 30.01.2026.
//

import Foundation
import FirebaseFirestore

final class CompanyProductDataModel {
    private var database: Firestore
    private let companyProductCollectionName: String = "CompanyProducts5"
    
    init(database: Firestore) {
        self.database = database
    }
    
    func getSnapshot() async throws -> QuerySnapshot {
        return try await database
            .collection(companyProductCollectionName)
            .getDocuments()
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
    
}
