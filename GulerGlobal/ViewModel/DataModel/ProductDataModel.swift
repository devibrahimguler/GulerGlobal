//
//  ProductDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 25.10.2025.
//

import SwiftUI
import FirebaseFirestore

final class ProductDataModel {
    let companyCollectionName: String
    let workCollectionName: String
    let productCollectionName: String
    let oldPricesCollectionName: String
    let database: Firestore
    
    let oldPriceDataModel: OldPriceDataModel
    
    init(companyCollectionName: String, workCollectionName: String, productCollectionName: String, oldPricesCollectionName: String, database: Firestore) {
        self.companyCollectionName = companyCollectionName
        self.workCollectionName = workCollectionName
        self.productCollectionName = productCollectionName
        self.oldPricesCollectionName = oldPricesCollectionName
        self.database = database
        self.oldPriceDataModel = .init(companyCollectionName: companyCollectionName, workCollectionName: workCollectionName, productCollectionName: productCollectionName, oldPricesCollectionName: oldPricesCollectionName, database: database)
    }
    
    func fetch(for snapshot: QuerySnapshot, companyId: String?) async throws -> [Product] {
        var productList: [Product] = []
        
        try await withThrowingTaskGroup(of: Product?.self) { group in
            for document in snapshot.documents {
                group.addTask { try await self.parse(from: document, companyId: companyId) }
            }
            
            for try await product in group {
                if let product = product {
                    productList.append(product)
                }
            }
        }
        
        return productList
    }
    
    // Create a Product for Company
    func create(_ companyId: String, _ product: Product) {
        Task {
            let data = cast(product)
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(productCollectionName).document(product.id)
                .setData(data)
        }
    }

    // Update a Product for Company
    func update(_ companyId: String, _ productId: String, updateArea: [String: Any]) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(productCollectionName).document(productId)
                .updateData(updateArea)
        }
    }

    // Delete a Product for Company
    func delete(_ companyId: String, _ productId: String) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(productCollectionName).document(productId)
                .delete()
            
        }
    }
    
    // Create a Product for Work
    func create(_ companyId: String, _ workId: String, _ product: Product) {
        Task {
            let data = cast(product)
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(workCollectionName).document(workId)
                .collection(productCollectionName).document(product.id)
                .setData(data)
        }
    }
    
    // Update a Product for Work
    func update(_ companyId: String, _ workId: String, _ productId: String, updateArea: [String: Any]) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(workCollectionName).document(workId)
                .collection(productCollectionName).document(productId)
                .updateData(updateArea)
        }
    }
    
    // Delete a Product for Work
    func delete(_ companyId: String, _ workId: String, _ productId: String) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(workCollectionName).document(workId)
                .collection(productCollectionName).document(productId)
                .delete()
            
        }
    }
    
    // Cast a Product
    private func cast(_ product: Product) -> [String: Any] {
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
    
    private func parse(from document: DocumentSnapshot, companyId: String?) async throws -> Product? {
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
        
        var oldPrice = [OldPrice]()
        if let companyId = companyId {
            oldPrice = []
            oldPrice = try await oldPriceDataModel.fetch(companyId: companyId, productId: id)
        }

        let product = Product(
            id: id,
            supplierId: supplierId,
            supplier: supplier,
            productName: productName,
            quantity: quantity,
            unitPrice: unitPrice,
            oldPrices: oldPrice,
            purchased: purchased
        )
        
        return product
    }
    
}
