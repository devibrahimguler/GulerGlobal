//
//  ProductViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 28.10.2025.
//

import SwiftUI
import FirebaseFirestore

final class ProductViewModel: ObservableObject {
    let dataService: FirebaseDataModel
    let fetch: () -> Void
    @Published var isLoading: Bool = false
    @Published var allProducts: [Product] = []
    @Published var companyList: [Company] = []
    @Published var productDetails = ProductDetails()
    
    init(dataService: FirebaseDataModel, fetch: @escaping () -> Void, isLoading: Bool, allProducts: [Product], companyList: [Company]) {
        self.dataService = dataService
        self.fetch = fetch
        self.isLoading = isLoading
        self.allProducts = allProducts
        self.companyList = companyList
    }
    
    func searchProducts(by name: String) -> [Product]? {
        guard !name.isEmpty else { return nil }
        return allProducts.filter { $0.productName.lowercased().hasPrefix(name.lowercased()) }
    }
    
    func updateProductDetails(with product: Product?) {
        productDetails = ProductDetails(from: product)
    }
    
    func createProductForWork(companyId: String, workId: String, product: Product) {
        isLoading = true
        dataService.companyDataModel.workDataModel.productDataModel.create(companyId, workId, product)
        fetch()
    }
    func updateProductForCompany(companyId: String, productId: String, updateArea: [String: Any]) {
        isLoading = true
        dataService.companyDataModel.workDataModel.productDataModel.update(companyId, productId, updateArea: updateArea)
    }
    func deleteProductForWork(companyId: String, workId: String, productId: String) {
        isLoading = true
        dataService.companyDataModel.workDataModel.productDataModel.delete(companyId, workId, productId)
        fetch()
    }
    
    func createProduct(companyId: String, product: Product) {
        isLoading = true
        dataService.companyDataModel.productDataModel.create(companyId, product)
        
        let oldPrice = OldPrice(price: product.unitPrice, date: product.purchased)
        dataService.companyDataModel.workDataModel.productDataModel.oldPriceDataModel.create(companyId, product.id, oldPrice)
        
        fetch()
    }
    func updateProduct(companyId: String, productId: String, updateArea: [String: Any]) {
        isLoading = true
        dataService.companyDataModel.productDataModel.update(companyId, productId, updateArea: updateArea)
        var price: Double?
        var date: Date?
        updateArea.forEach {
            if $0.key == "unitPrice" {
                price = $0.value as? Double
            }
            
            if $0.key == "purchased" {
                date = $0.value as? Date
            }
        }
        
        if let price = price {
            let oldPrice = OldPrice(price: price, date: date ?? .now)
            dataService.companyDataModel.workDataModel.productDataModel.oldPriceDataModel.create(companyId, productId, oldPrice)
        }
        fetch()
    }
}

