//
//  CompanyProductViewModel.swift
//  GulerGlobal
//
//  Refactored from MainViewModel — SRP: CompanyProduct CRUD only.
//

import SwiftUI

@MainActor
final class CompanyProductViewModel: ObservableObject {
    private let dataModel: CompanyProductDataModel
    
    @Published var companyProducts: [CompanyProduct] = []
    @Published var companyProductDetails = CompanyProductDetails()
    
    init(dataModel: CompanyProductDataModel) {
        self.dataModel = dataModel
    }
    
    // MARK: - Queries
    
    func getById(_ productId: String) -> CompanyProduct {
        return companyProducts.first(where: { $0.id == productId }) ?? example_CompanyProduct
    }
    
    func search(by name: String) -> [CompanyProduct]? {
        guard !name.isEmpty else { return nil }
        return companyProducts.filter { $0.name.lowercased().hasPrefix(name.lowercased()) }
    }
    
    func updateDetails(with product: CompanyProduct?) {
        companyProductDetails = CompanyProductDetails(from: product)
    }
    
    // MARK: - CRUD
    
    func create(product: CompanyProduct, setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                try await dataModel.saveCompanyProduct(product)
                await MainActor.run {
                    self.companyProducts.append(product)
                    setLoading(false)
                }
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                await MainActor.run {
                    setLoading(false)
                }
            }
        }
    }
    
    func update(productId: String, companyProductDetails: CompanyProductDetails, setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                guard
                    let index = self.companyProducts.firstIndex(where: { $0.id == productId }),
                    companyProductDetails.name != "",
                    companyProductDetails.quantity != "",
                    companyProductDetails.price != ""
                else { return }
                
                let name = companyProductDetails.name.trim()
                let quantity = companyProductDetails.quantity.toDouble()
                let price = companyProductDetails.price.toDouble()
                let date = companyProductDetails.date
                let oldPrices = companyProductDetails.oldPrices
                
                let updateArea = [
                    "name": name,
                    "quantity": quantity,
                    "price": price,
                    "date": date,
                    "oldPrices": oldPrices
                ]
                
                try await dataModel.updateCompanyProduct(productId, updateArea: updateArea)
                
                await MainActor.run {
                    self.companyProducts[index] = CompanyProduct(
                        id: productId,
                        companyId: self.companyProducts[index].companyId,
                        name: name,
                        quantity: quantity,
                        price: price,
                        date: date,
                        oldPrices: oldPrices
                    )
                    self.updateDetails(with: nil)
                    setLoading(false)
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                await MainActor.run {
                    setLoading(false)
                }
            }
        }
    }
    
    func delete(productId: String, setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                try await dataModel.deleteCompanyProduct(productId)
                await MainActor.run {
                    self.companyProducts.removeAll { $0.id == productId }
                    setLoading(false)
                }
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                await MainActor.run {
                    setLoading(false)
                }
            }
        }
    }
    
    func multipleDelete(productIds: [String], setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        dataModel.deleteMultipleCompanyProduct(productIds) { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                print("Toplu silme hatası: \(error.localizedDescription)")
                setLoading(false)
            } else {
                self.companyProducts.removeAll { productIds.contains($0.id) }
                setLoading(false)
            }
        }
    }
}
