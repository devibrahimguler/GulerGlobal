//
//  StatementDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 25.10.2025.
//

import SwiftUI
import FirebaseFirestore

final class StatementDataModel {
    let companyCollectionName: String
    let workCollectionName: String
    let statementCollectionName: String
    let database: Firestore
    
    init(companyCollectionName: String, workCollectionName: String, statementCollectionName: String, database: Firestore) {
        self.companyCollectionName = companyCollectionName
        self.workCollectionName = workCollectionName
        self.statementCollectionName = statementCollectionName
        self.database = database
    }
    
    // Fetch a Statement
    func fetch(for companyId: String) async throws -> [Statement] {
        let snapshot = try await database
            .collection(companyCollectionName).document(companyId)
            .collection(statementCollectionName)
            .getDocuments()
        
        var statementList: [Statement] = []
        
        try await withThrowingTaskGroup(of: Statement?.self) { group in
            for document in snapshot.documents {
                group.addTask { try await self.parse(from: document, companyId: companyId) }
            }
            
            for try await statement in group {
                if let statement = statement {
                    statementList.append(statement)
                }
            }
        }
        
        return statementList
    }
    
    // Create a Statement
    func create(_ companyId: String, _ statement: Statement) {
        Task {
            let data = cast(statement)
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(statementCollectionName).document(statement.id)
                .setData(data)
        }
    }

    // Update a Statement
    func update(_ companyId: String, _ statementId: String, updateArea: [String: Any]) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(statementCollectionName).document(statementId)
                .updateData(updateArea)
        }
    }

    // Delete a Statement
    func delete(_ companyId: String, _ statementId: String) {
        Task {
            try await database
                .collection(companyCollectionName).document(companyId)
                .collection(statementCollectionName).document(statementId)
                .delete()
        }
    }
    
    // Parse a Statement
    private func parse(from document: DocumentSnapshot, companyId: String) async throws -> Statement? {
        guard let data = document.data() else { return nil }
        
        guard
            let statementId = data["id"] as? String,
            let statementAmount = data["amount"] as? Double,
            let statementDate = (data["date"] as? Timestamp)?.dateValue()
        else { return nil }
        
        let statementStatus = StatementStatus(rawValue: data["status"] as? String ?? "") ?? .none
        
        return Statement(
            id: statementId,
            amount: statementAmount,
            date: statementDate,
            status: statementStatus
        )
    }
    
    // Cast a Statement
    private func cast(_ statement: Statement) -> [String: Any] {
        return [
            "id": statement.id,
            "amount": statement.amount,
            "date": statement.date,
            "status": statement.status.rawValue
        ]
    }
}
