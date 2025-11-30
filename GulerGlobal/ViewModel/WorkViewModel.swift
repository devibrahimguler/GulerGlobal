//
//  WorkViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 28.10.2025.
//

import SwiftUI

final class WorkViewModel: ObservableObject {
    let dataService: FirebaseDataModel
    let fetch: () -> Void
    @Published var workDetails = WorkDetails()
    @Published var isLoading: Bool = false
    let allProducts: [Product]
    let allTasks: [TupleModel]
    @Published var companyList: [Company] = []

    
    init(fetch: @escaping () -> Void, dataService:FirebaseDataModel, isLoading: Bool, allProducts: [Product], allTasks: [TupleModel], companyList: [Company]) {
        self.fetch = fetch
        self.dataService = dataService
        self.isLoading = isLoading
        self.allProducts = allProducts
        self.allTasks = allTasks
        self.companyList = companyList
    }
    
    func generateUniqueID() -> String {
        let highestID = allTasks.compactMap {  Int($0.work.id) }.max() ?? 0
        return String(format: "%04d", highestID + 1)
    }
    
    func updateWorkDetails(with work: Work?) {
        workDetails = WorkDetails(from: work)
    }
    
    func workCreate(companyId: String, work: Work) {
        isLoading = true
        dataService.companyDataModel.workDataModel.create(companyId, work)
        fetch()
    }
    
    func workUpdate(companyId: String, workId: String, updateArea: [String: Any]) {
        isLoading = true
        dataService.companyDataModel.workDataModel.update(companyId, workId, updateArea: updateArea)
        fetch()
    }
}

