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
    var modelContext: ModelContext
    var companies: [Company]?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        fetchData()
    }
    
    func fetchData() {
        do {
            
            let descriptorCompany = FetchDescriptor<Company>(sortBy: [SortDescriptor(\.id)])
            companies = try modelContext.fetch(descriptorCompany)
            
            if companies == [] {
                companies = [
                    Company(name: "Şirket İsmi", desc: "Şirket Açıklaması", adress: "Şirket Adresi", phone: "5541701635", work: Work(name: "İş İsmi", desc: "İş Açıklaması", price: 1000, recMoney: 500, remMoney: 500, stTime: .now, fnTime: .now)),
                    Company(name: "Şirket İsmi", desc: "Şirket Açıklaması", adress: "Şirket Adresi", phone: "5541701635", work: Work(name: "İş İsmi", desc: "İş Açıklaması", price: 1000, recMoney: 500, remMoney: 500, stTime: .now, fnTime: .now)),
                    Company(name: "Şirket İsmi 2", desc: "Şirket Açıklaması 2", adress: "Şirket Adresi 2", phone: "5541701635", work: Work(name: "İş İsmi 2", desc: "İş Açıklaması 2", price: 1000, recMoney: 500, remMoney: 500, stTime: .now, fnTime: .now)),
                    Company(name: "Şirket İsmi 3", desc: "Şirket Açıklaması 3", adress: "Şirket Adresi 3", phone: "5541701635", work: Work(name: "İş İsmi 3", desc: "İş Açıklaması 3", price: 1000, recMoney: 500, remMoney: 500, stTime: .now, fnTime: .now)),
                    Company(name: "Şirket İsmi 4", desc: "Şirket Açıklaması 4", adress: "Şirket Adresi 4", phone: "5541701635", work: Work(name: "İş İsmi 4", desc: "İş Açıklaması 4", price: 1000, recMoney: 500, remMoney: 500, stTime: .now, fnTime: .now))]
            }
            
        } catch {
            print("Fetch failed")
        }
    }
    
    func fetchCompanyWorks(companyName: String) -> [Work]? {
        var companyWorks = [Work]()
         if let companies = companies {
             for company in companies.filter({ $0.name == companyName }) {
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

