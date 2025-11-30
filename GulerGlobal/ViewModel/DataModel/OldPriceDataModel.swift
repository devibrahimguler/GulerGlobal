//
//  OldPriceDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 25.10.2025.
//

import SwiftUI
import FirebaseFirestore

final class OldPriceDataModel {
    let companyCollectionName: String
    let workCollectionName: String
    let productCollectionName: String
    let oldPricesCollectionName: String
    let database: Firestore
    
    init(companyCollectionName: String, workCollectionName: String, productCollectionName: String, oldPricesCollectionName: String, database: Firestore) {
        self.companyCollectionName = companyCollectionName
        self.workCollectionName = workCollectionName
        self.productCollectionName = productCollectionName
        self.oldPricesCollectionName = oldPricesCollectionName
        self.database = database
    }
    
    // Fetch a OldPrice
    func fetch(companyId: String, productId: String) async throws -> [OldPrice] {
        let snapshot = try await database
            .collection(companyCollectionName).document(companyId)
            .collection(productCollectionName).document(productId)
            .collection(oldPricesCollectionName)
            .getDocuments()
        
        return snapshot.documents.compactMap { parse(from: $0) }
    }
    
    // Create a OldPrice
    func create(_ companyId: String,  _ productId: String,_ oldPrice: OldPrice) {
        Task {
            let data = cast(oldPrice)
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(productCollectionName).document(productId)
                .collection(oldPricesCollectionName).document(oldPrice.id)
                .setData(data)
        }
    }

    // Update a OldPrice
    func update(_ companyId: String, _ productId: String, _ oldPriceId: String, updateArea: [String: Any]) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(productCollectionName).document(productId)
                .collection(oldPricesCollectionName).document(oldPriceId)
                .updateData(updateArea)
        }
    }

    // Delete a OldPrice
    func delete(_ companyId: String, _ productId: String, _ oldPriceId: String) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(productCollectionName).document(productId)
                .collection(oldPricesCollectionName).document(oldPriceId)
                .delete()
        }
    }
    
    // Parse a OldPrice
    private func parse(from document: DocumentSnapshot) -> OldPrice? {
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
    
    // Cast a OldPrice
    private func cast(_ oldPrice: OldPrice) -> [String: Any] {
        return [
            "id": oldPrice.id,
            "price": oldPrice.price,
            "date": oldPrice.date,
        ]
    }
}
