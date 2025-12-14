//
//  WorkProductDetails.swift
//  GulerGlobal
//
//  Created by ibrahim on 14.12.2025.
//

import Foundation

struct WorkProductDetails {
    var quantity: String = ""
    var date: Date = .now
    
    init() {}
    
    init(from product: CompanyProduct?) {
        quantity = "\(product?.quantity ?? 0)"
        date = product?.date ?? .now
    }
}
