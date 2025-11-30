//
//  ProductDetails.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 22.10.2025.
//

import SwiftUI

// MARK: - Supporting Models

struct ProductDetails {
    var supplier: String = ""
    var name: String = ""
    var unitPrice: String = ""
    var quantity: String = ""
    var purchased: Date = .now
    var oldPrices: [OldPrice] = []
    
    init() {}
    
    init(from product: Product?) {
        supplier = product?.supplier ?? ""
        name = product?.productName ?? ""
        quantity = "\(product?.quantity ?? 0)"
        unitPrice = "\(product?.unitPrice ?? 0)"
        purchased = product?.purchased ?? .now
    }
}
