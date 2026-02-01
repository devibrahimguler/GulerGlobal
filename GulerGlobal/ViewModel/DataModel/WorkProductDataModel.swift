//
//  WorkProductDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim on 30.01.2026.
//

import Foundation
import FirebaseFirestore

final class WorkProductDataModel {
    private var database: Firestore
    private let workProductCollectionName: String = "WorkProducts5"
    
    init(database: Firestore) {
        self.database = database
    }
    
    func getSnapshot() async throws -> QuerySnapshot {
        return try await database
            .collection(workProductCollectionName)
            .getDocuments()
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
    
}
