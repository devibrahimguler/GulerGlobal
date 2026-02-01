//
//  FirebaseDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import Foundation
import FirebaseFirestore

final class FirebaseDataModel {
    private let database: Firestore = Firestore.firestore()
    
    let companyDataModel: CompanyDataModel
    let workDataModel: WorkDataModel
    let companyProductDataModel: CompanyProductDataModel
    let workProductDataModel: WorkProductDataModel
    let statementDataModel: StatementDataModel
    
    init() {
        companyDataModel = .init(database: database)
        workDataModel = .init(database: database)
        companyProductDataModel = .init(database: database)
        workProductDataModel = .init(database: database)
        statementDataModel = .init(database: database)
    }
    
    // Fetch all data from the database
    @MainActor
    func fetchAllData(completion: @escaping (Result<([Company], [Work], [CompanyProduct], [WorkProduct], [Statement]), Error>) -> Void) {
        Task {
            do {
                let companySnapshot = try await companyDataModel.getSnapshot()
                let workSnapshot = try await workDataModel.getSnapshot()
                let companyProductSnapshot = try await companyProductDataModel.getSnapshot()
                let workProductSnapshot = try await workProductDataModel.getSnapshot()
                let statementSnapshot = try await statementDataModel.getSnapshot()
                
                let (companyResult, workResult, companyProductResult, workProductResult, statementResult) = (companySnapshot, workSnapshot, companyProductSnapshot, workProductSnapshot, statementSnapshot)
                
                var companies: [Company] = []
                var works: [Work] = []
                var companyProducts: [CompanyProduct] = []
                var workProducts: [WorkProduct] = []
                var statements: [Statement] = []
                
                companies = companyResult.documents.compactMap { doc -> Company? in try? doc.data(as: Company.self) }
                works = workResult.documents.compactMap { doc -> Work? in try? doc.data(as: Work.self) }
                companyProducts = companyProductResult.documents.compactMap { doc -> CompanyProduct? in try? doc.data(as: CompanyProduct.self) }
                workProducts = workProductResult.documents.compactMap { doc -> WorkProduct? in try? doc.data(as: WorkProduct.self) }
                statements = statementResult.documents.compactMap { doc -> Statement? in try? doc.data(as: Statement.self) }
                
                
                completion(.success((companies,works,companyProducts,workProducts,statements)))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    
    
    
    

    
    
    
    
    
}
