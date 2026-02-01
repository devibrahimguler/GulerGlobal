//
//  StatementDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim on 30.01.2026.
//

import Foundation
import FirebaseFirestore

final class StatementDataModel {
    private var database: Firestore
    private let statementCollectionName: String = "Statements5"
    
    init(database: Firestore) {
        self.database = database
    }
    
    func getSnapshot() async throws -> QuerySnapshot {
        return try await database
            .collection(statementCollectionName)
            .getDocuments()
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
