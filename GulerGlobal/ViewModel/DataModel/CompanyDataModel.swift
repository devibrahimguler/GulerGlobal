//
//  CompanyDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 25.10.2025.
//

import SwiftUI
import FirebaseFirestore

final class CompanyDataModel {
    let companyCollectionName: String
    let workCollectionName: String
    let productCollectionName: String
    let oldPricesCollectionName: String
    let statementCollectionName: String
    let database: Firestore
    let workDataModel: WorkDataModel
    let productDataModel: ProductDataModel
    let statementDataModel: StatementDataModel
    
    init(companyCollectionName: String, workCollectionName: String, productCollectionName: String, oldPricesCollectionName: String, statementCollectionName: String, database: Firestore) {
        self.companyCollectionName = companyCollectionName
        self.workCollectionName = workCollectionName
        self.productCollectionName = productCollectionName
        self.oldPricesCollectionName = oldPricesCollectionName
        self.statementCollectionName = statementCollectionName
        self.database = database
        self.workDataModel = .init(companyCollectionName: companyCollectionName, workCollectionName: workCollectionName, productCollectionName: productCollectionName, oldPricesCollectionName: oldPricesCollectionName, database: database)
        self.productDataModel = .init(companyCollectionName: companyCollectionName, workCollectionName: workCollectionName, productCollectionName: productCollectionName, oldPricesCollectionName: oldPricesCollectionName, database: database)
        self.statementDataModel = .init(companyCollectionName: companyCollectionName, workCollectionName: workCollectionName, statementCollectionName: statementCollectionName, database: database)
    }
    
    // Fetch a Company
    @MainActor
    func fetch(completion: @escaping (Result<[Company], Error>) -> Void) {
        Task {
            do {
                let snapshot = try await database.collection(companyCollectionName).getDocuments()
                var companyList: [Company] = []
                
                try await withThrowingTaskGroup(of: Company?.self) { group in
                    for document in snapshot.documents {
                        group.addTask { try await self.parse(from: document) }
                    }
                    
                    for try await company in group {
                        if let company = company {
                            companyList.append(company)
                        }
                    }
                }
                
                completion(.success(companyList))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Create a Company
    func create(_ company: Company) {
        Task {
            let data = cast(company)
            try await database.collection(companyCollectionName).document(company.id)
                .setData(data)
        }
    }

    // Update a Company
    func update(_ companyId: String, updateArea: [String: Any]) {
        Task {
            try await database.collection(companyCollectionName).document(companyId)
                .updateData(updateArea)
        }
    }
    
    // Delete a Company
    func delete(_ companyId: String) {
        Task {
            try await database.collection(companyCollectionName).document(companyId)
                .delete()
        }
    }
    
    // Parse a Company
    private func parse(from document: DocumentSnapshot) async throws -> Company? {
        guard let data = document.data() else { return nil }
        
        guard
            let id = data["id"] as? String,
            let name = data["name"] as? String,
            let address = data["address"] as? String,
            let number = data["number"] as? String,
            let partnerRoleRawValue = data["partnerRole"] as? String
        else { return nil }
        
        let snapshot = try await database
            .collection(companyCollectionName).document(id)
            .collection(productCollectionName)
            .getDocuments()
        
        
        let partnerRole = PartnerRole(rawValue: partnerRoleRawValue) ?? .none
        let works = try await workDataModel.fetch(for: id)
        let statements = try await statementDataModel.fetch(for: id)
        let products = try await productDataModel.fetch(for: snapshot, companyId: id)
        
        let company = Company(
            id: id,
            name: name,
            address: address,
            number: number,
            partnerRole: partnerRole,
            works: works,
            statements: statements,
            products: products
        )
        
        return company
    }
    
    // Cast a Company
    private func cast(_ company: Company) -> [String: Any] {
        return [
            "id": company.id,
            "name": company.name,
            "address": company.address,
            "number": company.number,
            "partnerRole": company.partnerRole.rawValue
        ]
    }
}
