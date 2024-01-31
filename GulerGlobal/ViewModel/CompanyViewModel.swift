//
//  CompanyViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import CoreData

class CompanyViewModel : ObservableObject {
    
    @Published var companies: [Companies] = []
    @Published  var works: [String: [Work]] = [:]
    
    private let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "GulerGlobal")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        fetchData()
    }

    func fetchCompany(value: String) -> Companies? {
        return companies.first(where: { $0.name == value })
    }
    
    // Pulls data from Core Data.
    func fetchData() {
        let request = NSFetchRequest<Companies>(entityName: "Companies")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Companies.id, ascending: false)]
        
        do {
            let companies = try container.viewContext.fetch(request)
            DispatchQueue.main.async {
                self.companies = companies
            }
            
        } catch {
            print("Veriler alınamadı: \(error.localizedDescription)")
        }
        
    }
    
    // Adds Data to Core Data.
    func create(company: Company) {
        
        addingModel(company: company)
        save()
        fetchData()
    }
    
    // Update Data to Core Data.
    func update(company: Company) {
        
        addingModel(company: company)
        save()
        fetchData()
    }
    
    
    // Saves data to Core Data.
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // Model.
    private func addingModel(company: Company) {
        let newCompany = Companies(context: container.viewContext)
        let newWork = Works(context: container.viewContext)
        let newAccept = Accepts(context: container.viewContext)
        
        newCompany.id = company.id
        newCompany.name = company.name
        newCompany.adress = company.adress
        newCompany.phone = company.phone

        newWork.id = company.work.id
        newWork.pNum = company.work.pNum
        newWork.name = company.work.name
        newWork.desc = company.work.desc
        newWork.price = company.work.price
        
        newAccept.recMoney = company.work.accept?.recMoney ?? 0
        newAccept.remMoney = company.work.accept?.remMoney ?? 0
        newAccept.stTime = company.work.accept?.stTime
        newAccept.fnTime = company.work.accept?.fnTime
        
        newWork.accept = newAccept
        newCompany.work = newWork
    }
    
}
