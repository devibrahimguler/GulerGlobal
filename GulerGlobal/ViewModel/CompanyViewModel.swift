//
//  CompanyViewModel.swift
//  GulerGlobal
//
//  Refactored from MainViewModel — SRP: Company CRUD only.
//

import SwiftUI

@MainActor
final class CompanyViewModel: ObservableObject {
    private let dataModel: CompanyDataModel
    
    @Published var companies: [Company] = []
    @Published var companyDetails = CompanyDetails()
    
    init(dataModel: CompanyDataModel) {
        self.dataModel = dataModel
    }
    
    // MARK: - Queries
    
    func getById(_ companyId: String) -> Company {
        return companies.first(where: { $0.id == companyId }) ?? example_Company
    }
    
    func generateUniqueID() -> String {
        let highestID = companies.compactMap { Int($0.id) }.max() ?? 0
        return String(highestID + 1)
    }
    
    func search(by name: String) -> [Company]? {
        guard !name.isEmpty else { return nil }
        return companies.filter { $0.name.lowercased().hasPrefix(name.lowercased()) }
    }
    
    func updateDetails(with company: Company?) {
        companyDetails = CompanyDetails(from: company)
    }
    
    // MARK: - CRUD
    
    func create(company: Company, setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                try await dataModel.saveCompany(company)
                await MainActor.run {
                    self.companies.append(company)
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
    
    func update(companyId: String, companyDetails: CompanyDetails, setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                guard
                    let index = self.companies.firstIndex(where: { $0.id == companyId }),
                    companyDetails.name != "",
                    companyDetails.address != ""
                else { return }
                
                let name = companyDetails.name.trim()
                let address = companyDetails.address.trim()
                let phone = companyDetails.phone
                let status = companyDetails.status
                
                let updateArea = [
                    "name": name,
                    "address": address,
                    "phone": phone,
                    "status": status.rawValue
                ]
                
                try await dataModel.updateCompany(companyId, updateArea: updateArea)
                
                await MainActor.run {
                    self.companies[index] = Company(
                        id: companyId,
                        name: name,
                        address: address,
                        phone: phone,
                        status: status
                    )
                    self.updateDetails(with: nil)
                    setLoading(false)
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                await MainActor.run {
                    self.updateDetails(with: nil)
                    setLoading(false)
                }
            }
        }
    }
    
    func delete(companyId: String, setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                try await dataModel.deleteCompany(companyId)
                await MainActor.run {
                    self.companies.removeAll { $0.id == companyId }
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
}
