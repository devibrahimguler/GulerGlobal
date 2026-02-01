//
//  CompanyDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim on 30.01.2026.
//

import Foundation
import FirebaseFirestore

final class CompanyDataModel {
    private var database: Firestore
    private let companyCollectionName: String = "Companies5"
    
    init(database: Firestore) {
        self.database = database
    }
    
    func getSnapshot() async throws -> QuerySnapshot {
        return try await database
            .collection(companyCollectionName)
            .getDocuments()
    }
    
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
    
}
