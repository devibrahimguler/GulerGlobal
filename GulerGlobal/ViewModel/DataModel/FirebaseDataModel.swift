//
//  FirebaseDataModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import Foundation
import FirebaseFirestore

final class FirebaseDataModel: ObservableObject {
    let companyCollectionName: String = "Companies2"
    let workCollectionName: String = "WorkList"
    let productCollectionName: String = "ProductList"
    let statementCollectionName: String = "StatementList"
    let oldPricesCollectionName: String = "OldPricesList"
    
    let companyDataModel: CompanyDataModel
    
    private let database: Firestore = Firestore.firestore()
    
    init() {
        self.companyDataModel = .init(companyCollectionName: companyCollectionName, workCollectionName: workCollectionName, productCollectionName: productCollectionName, oldPricesCollectionName: oldPricesCollectionName, statementCollectionName: statementCollectionName, database: database)
    }
}
