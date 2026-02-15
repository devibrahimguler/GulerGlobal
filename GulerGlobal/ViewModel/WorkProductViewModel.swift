//
//  WorkProductViewModel.swift
//  GulerGlobal
//
//  Refactored from MainViewModel — SRP: WorkProduct CRUD only.
//

import SwiftUI

@MainActor
final class WorkProductViewModel: ObservableObject {
    private let dataModel: WorkProductDataModel
    private let companyProductDataModel: CompanyProductDataModel
    
    @Published var workProducts: [WorkProduct] = []
    @Published var workProductDetails = WorkProductDetails()
    
    init(dataModel: WorkProductDataModel, companyProductDataModel: CompanyProductDataModel) {
        self.dataModel = dataModel
        self.companyProductDataModel = companyProductDataModel
    }
    
    // MARK: - Queries
    
    func getById(_ workId: String) -> [WorkProduct] {
        return workProducts.filter { $0.workId == workId }
    }
    
    func updateDetails(with product: CompanyProduct?) {
        workProductDetails = WorkProductDetails(from: product)
    }
    
    // MARK: - CRUD
    
    func create(product: WorkProduct, setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                try await dataModel.saveWorkProduct(product)
                await MainActor.run {
                    self.workProducts.append(product)
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
    
    func update(productId: String, workProductDetails: WorkProductDetails,
                           companyProductVM: CompanyProductViewModel,
                           setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                guard
                    let workIndex = self.workProducts.firstIndex(where: { $0.productId == productId }),
                    let companyIndex = companyProductVM.companyProducts.firstIndex(where: { $0.id == productId }),
                    workProductDetails.quantity != ""
                else { return }
                
                let quantity = workProductDetails.quantity.toDouble()
                let companyQuantity = companyProductVM.companyProducts[companyIndex].quantity - quantity
                let workUpdateArea = [
                    "quantity": quantity
                ]
                
                let companyUpdateArea = [
                    "quantity": companyQuantity
                ]
                
                try await dataModel.updateWorkProduct(productId, updateArea: workUpdateArea)
                try await companyProductDataModel.updateCompanyProduct(productId, updateArea: companyUpdateArea)
                
                await MainActor.run {
                    self.workProducts[workIndex] = WorkProduct(
                        id: self.workProducts[workIndex].id,
                        workId: self.workProducts[workIndex].workId,
                        productId: self.workProducts[workIndex].productId,
                        quantity: quantity,
                        date: self.workProducts[workIndex].date
                    )
                    
                    companyProductVM.companyProducts[companyIndex].quantity = companyQuantity
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
                try await dataModel.deleteWorkProduct(productId)
                await MainActor.run {
                    self.workProducts.removeAll { $0.productId == productId }
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
        dataModel.deleteMultipleWorkProduct(productIds) { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                print("Toplu silme hatası: \(error.localizedDescription)")
                setLoading(false)
            } else {
                self.workProducts.removeAll { productIds.contains($0.id) }
                setLoading(false)
            }
        }
    }
}
