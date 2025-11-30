//
//  Company.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.03.2024.
//

import SwiftUI
import FirebaseFirestore

/*
 struct Company: Codable, Hashable, Identifiable {
     var id: String
     var companyName: String
     var companyAddress: String
     var contactNumber: String
     var partnerRole: PartnerRole
     var workList: [Work]
     var statements: [Statement]
     var productList: [Product]
 }
 
 enum PartnerRole: Codable {
     case current, supplier, both, debt
 }
 */



struct TupleModel: Hashable, Identifiable {
    let id: String = UUID().uuidString
    let company: Company
    let work: Work
}

struct Company: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var address: String
    var phone: String
    var status: CompanyStatus
}

enum CompanyStatus: String, Codable, CaseIterable {
    case current = "current"
    case supplier = "supplier"
    case both = "both"
    case debt = "debt"
}

struct Work: Identifiable, Codable, Hashable {
    var id: String
    var companyId: String
    var name: String
    var description: String
    var cost: Double
    var status: ApprovalStatus
    var startDate: Date
    var endDate: Date
    var products: [WorkProduct]?
}

struct WorkProduct: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var workId: String
    var productId: String
    var quantity: Double
    var date: Date
}

enum ApprovalStatus: String, Codable {
    case approved = "approved"
    case pending = "pending"
    case rejected = "rejected"
    case finished = "finished"
}

struct Statement: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var companyId: String
    var amount: Double
    var date: Date
    var status: StatementStatus
}

struct Product: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var companyId: String
    var name: String
    var quantity: Double
    var price: Double
    var date: Date
    var oldPrices: [OldPrice]
}

struct OldPrice: Codable, Hashable {
    var id: String = UUID().uuidString
    var price: Double
    var date: Date
}
