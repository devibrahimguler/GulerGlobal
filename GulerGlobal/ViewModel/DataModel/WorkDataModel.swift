//
//  WorkDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 25.10.2025.
//

import SwiftUI
import FirebaseFirestore

final class WorkDataModel {
    let companyCollectionName: String
    let workCollectionName: String
    let productCollectionName: String
    let oldPricesCollectionName: String
    let database: Firestore
    let productDataModel: ProductDataModel
    
    init(companyCollectionName: String, workCollectionName: String, productCollectionName: String, oldPricesCollectionName: String, database: Firestore) {
        self.companyCollectionName = companyCollectionName
        self.workCollectionName = workCollectionName
        self.productCollectionName = productCollectionName
        self.oldPricesCollectionName = oldPricesCollectionName
        self.database = database
        self.productDataModel = ProductDataModel(companyCollectionName: companyCollectionName, workCollectionName: workCollectionName, productCollectionName: productCollectionName, oldPricesCollectionName: oldPricesCollectionName, database: database)
    }
    
    // Fetch a Work
    func fetch(for companyId: String) async throws -> [Work] {
        let snapshot = try await database.collection(companyCollectionName).document(companyId).collection(workCollectionName).getDocuments()
        var workList: [Work] = []
        
        try await withThrowingTaskGroup(of: Work?.self) { group in
            for document in snapshot.documents {
                group.addTask { try await self.parse(from: document, companyId: companyId) }
            }
            
            for try await work in group {
                if let work = work {
                    workList.append(work)
                }
            }
        }
        
        return workList
    }
    
    // Create a Work
    func create(_ companyId: String, _ work: Work) {
        Task {
            let data = cast(work)
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(workCollectionName).document(work.id)
                .setData(data)
        }
    }

    // Update a Work
    func update(_ companyId: String, _ workId: String, updateArea: [String: Any]) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(workCollectionName).document(workId)
                .updateData(updateArea)
        }
    }

    // Delete a Work
    func delete(_ companyId: String, _ workId: String) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(workCollectionName).document(workId)
                .delete()
        }
    }
    
    // Parse a Work
    private func parse(from document: DocumentSnapshot, companyId: String) async throws -> Work? {
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
        
        let snapshot = try await database
            .collection(companyCollectionName).document(companyId)
            .collection(workCollectionName).document(workId)
            .collection(productCollectionName)
            .getDocuments()
        
        let approve = ApprovalStatus(rawValue: approveRawValue) ?? .none
        let productList = try await productDataModel.fetch(for: snapshot, companyId: companyId)
        
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
    
    // Cast a Work
    private func cast(_ work: Work) -> [String: Any] {
        return [
            "id": work.id,
            "workName": work.workName,
            "workDescription": work.workDescription,
            "remainingBalance": work.remainingBalance,
            "totalCost": work.totalCost,
            "approve": work.approve.rawValue,
            "startDate": work.startDate,
            "endDate": work.endDate
        ]
    }
}
