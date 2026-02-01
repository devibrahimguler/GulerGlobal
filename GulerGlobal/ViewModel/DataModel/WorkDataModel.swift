//
//  WorkDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim on 30.01.2026.
//

import Foundation
import FirebaseFirestore

final class WorkDataModel {
    private var database: Firestore
    private let workCollectionName: String = "Works5"
    
    init(database: Firestore) {
        self.database = database
    }
    
    func getSnapshot() async throws -> QuerySnapshot {
        return try await database
            .collection(workCollectionName)
            .getDocuments()
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
    
    
}
