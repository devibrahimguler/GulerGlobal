//
//  CompanyProductDetails.swift
//  GulerGlobal
//
//  Created by ibrahim on 14.12.2025.
//

import Foundation

struct CompanyProductDetails {
    var supplier: String = ""
    var name: String = ""
    var price: String = ""
    var quantity: String = ""
    var date: Date = .now
    var oldPrices: [OldPrice] = []
    
    init() {}
    
    init(from product: CompanyProduct?) {
        name = product?.name ?? ""
        quantity = "\(product?.quantity ?? 0)"
        price = "\(product?.price ?? 0)"
        date = product?.date ?? .now
        oldPrices = product?.oldPrices ?? []
    }
}
