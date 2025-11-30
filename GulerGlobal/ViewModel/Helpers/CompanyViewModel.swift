//
//  CompanyViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 22.10.2025.
//

import SwiftUI

@MainActor
class CompanyViewModel: ObservableObject {
    // MARK: - Dependencies
    private let firebaseDataService = FirebaseDataModel()
    private let workViewModel = WorkViewModel()
    private let mainViewModel = MainViewModel()
    
    @Published var companyList: [Company] = []
    @Published var companyDetails = CompanyDetails()
    
    private func generateUniqueID() -> String {
        let highestID = companyList.compactMap {  Int($0.id) }.max() ?? 0
        return String(highestID + 1)
    }
    
    func updateCompanyDetails(with company: Company?) {
        companyDetails = CompanyDetails(from: company)
    }
    
    func createCompany(partnerRole: PartnerRole, hasAlert: inout Bool) {
        guard
            companyDetails.name != "",
            companyDetails.address != ""
        else { return }
        
        if companyList.first(where: { $0.companyName == companyDetails.name }) != nil {
            hasAlert = true
        } else {
            
            let companyName = companyDetails.name.trim()
            let companyAddress = companyDetails.address.trim()
            let contactNumber = companyDetails.contactNumber
            
            let newCompany = Company(
                id: generateUniqueID(),
                companyName: companyName,
                companyAddress: companyAddress,
                contactNumber: contactNumber,
                partnerRole: partnerRole,
                workList: [],
                statements: [],
                productList: []
            )
            
            firebaseDataService.saveCompany(newCompany)
            // MARK: - creating
            mainViewModel.createWork(companyId: newCompany.id, work: example_Work)
            
        }
    }
    
    func updateCompany(companyId: String, updateArea: [String: Any], isLoading: inout Bool) {
        isLoading = true
        firebaseDataService.updateCompany(companyId, updateArea: updateArea)
        mainViewModel.fetchData()
    }
    
}
