//
//  WorkDetailViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim on 15.12.2025.
//

import Foundation

@MainActor
final class WorkDetailViewModel: ObservableObject {
    let firebaseDataService: FirebaseDataModel
    @Published var workDetails = WorkDetails()
    @Published var workProductDetails = WorkProductDetails()
    
    init(firebaseDataService: FirebaseDataModel) {
        self.firebaseDataService = firebaseDataService
    }
    
    func updateWorkDetails(with work: Work?) {
        workDetails = WorkDetails(from: work)
    }
    
    func updateWorkProductDetails(with product: CompanyProduct?) {
        workProductDetails = WorkProductDetails(from: product)
    }
    
    func getWorkProductsById(_ workId: String) -> [WorkProduct] {
        return AppState.shared.workProducts.filter { $0.workId == workId }
    }
    
    func workUpdate(workId: String, updateArea: [String: Any]) {
        AppState.shared.isLoading = true
        Task {
            do {
                try await firebaseDataService.updateWork(workId, updateArea: updateArea)

                await MainActor.run {
                    self.fetchWorkData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    AppState.shared.isLoading = false
                }
            }
        }
    }
    
    private func fetchWorkData(completion: (() -> Void)? = nil) {
        AppState.shared.isLoading = true
        
        self.firebaseDataService.fetchWorks { [weak self] result in
            guard self != nil else {
                completion?()
                return
            }
            
            switch result {
            case .failure(let error):
                print("Fetch error: \(error.localizedDescription)")
                AppState.shared.isLoading = false
                
            case .success(let works):
                AppState.shared.works = works.sorted(by: { $0.id > $1.id })
                AppState.shared.isLoading = false
            }
            
            completion?()
        }
    }
    
    func workProductCreate(product: WorkProduct) {
        AppState.shared.isLoading = true
        
        Task {
            do {
                try await firebaseDataService.saveWorkProduct(product)

                await MainActor.run {
                    self.fetchWorkProductData()
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    AppState.shared.isLoading = false
                }
            }
        }
    }
    
    private func fetchWorkProductData(completion: (() -> Void)? = nil) {
        AppState.shared.isLoading = true
        
        self.firebaseDataService.fetchWorkProducts { [weak self] result in
            guard self != nil else {
                completion?()
                return
            }
            
            switch result {
            case .failure(let error):
                print("Fetch error: \(error.localizedDescription)")
                AppState.shared.isLoading = false
                
            case .success(let workProducts):
                AppState.shared.workProducts = workProducts.sorted(by: { $0.date > $1.date })
                AppState.shared.isLoading = false
            }
            
            completion?()
        }
    }
    
    func companyProductUpdate(productId: String, updateArea: [String: Any]) {
        AppState.shared.isLoading = true
        Task {
            do {
                try await firebaseDataService.updateCompanyProduct(productId, updateArea: updateArea)
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                
                await MainActor.run {
                    AppState.shared.isLoading = false
                }
            }
        }
    }
    
    func searchCompanies(by name: String) -> [Company]? {
        guard !name.isEmpty else { return nil }
        return AppState.shared.companies.filter { $0.name.lowercased().hasPrefix(name.lowercased()) }
    }
}
