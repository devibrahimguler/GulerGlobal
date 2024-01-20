//
//  CompanyViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import Foundation
import SwiftData

@Observable
final class CompanyViewModel {
    private var allCompanies: [Company]?
    
    var modelContext: ModelContext
    var companies: [Company]?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        fetchData()
    }
    
    func fetchData() {
        do {
            
            let descriptorCompany = FetchDescriptor<Company>(sortBy: [SortDescriptor(\.name)])
            companies = try modelContext.fetch(descriptorCompany)
        
            allCompanies = companies
            var newCompanies = [Company]()
            
            companies?.forEach({ company in
                guard !newCompanies.contains(where: { contains in contains.name == company.name }) else { return }
                newCompanies.append(company)
            })
            
            companies = newCompanies
            
        } catch {
            print("Fetch failed")
        }
    }
    
    func fetchCompanyWorks(name: String) -> [Work]? {
        var companyWorks = [Work]()
         if allCompanies != [] {
             let newCompany = allCompanies!.filter({ $0.name == name })
             for company in newCompany {
                 companyWorks.append(company.work)
             }
         }
        return companyWorks
    }
    
    func createNewGame(workName: String, workDesc: String, workPrice: String, workRecMoney: String, workRemMoney: String, workStTime: Date, workFnTime: Date?, companyName: String, companyDesc: String, companyAdress: String, companyPhone: String) {
        if companyName != "" {
            if companyDesc != "" {
                if companyAdress != "" {
                    if companyPhone != "" {
                        if workName != "" {
                            if workDesc != "" {
                                if workPrice != "" {
                                    if workRecMoney != "" {
                                        if workRemMoney != "" {
                                            
                                            let company = Company(name: companyName, desc: companyDesc, adress: companyAdress, phone: companyPhone, work: Work(name: workName, desc: workDesc, price: Double(workPrice) ?? 0.0, recMoney: Double(workRecMoney) ?? 0.0, remMoney: Double(workRemMoney) ?? 0.0, stTime: workStTime, fnTime: workFnTime))
                                            
                                            modelContext.insert(company)
                                            fetchData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
}

