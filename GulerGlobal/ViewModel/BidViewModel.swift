//
//  BidViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim on 15.12.2025.
//

import SwiftUI

@MainActor
final class BidViewModel: ObservableObject {
    
    let firebaseDataService: FirebaseDataModel
    
    init(firebaseDataService: FirebaseDataModel) {
        self.firebaseDataService = firebaseDataService
    }
    
    func getCompanyById(_ companyId: String) -> Company {
        return AppState.shared.companies.first(where: { $0.id == companyId }) ?? example_Company
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
}
