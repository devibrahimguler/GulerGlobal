//
//  CompanyViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import CoreData

class CompanyViewModel : ObservableObject {
    
    @Published var companies: [Company] = []
    @Published var waitCompanies: [Company] = []
    @Published var approveCompanies: [Company] = []
    @Published var notApproveCompanies: [Company] = []
    
    let container: NSPersistentContainer
    
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

    func fetchCompany(value: String) -> Company? {
        return companies.first(where: { $0.name == value })
    }
    
    // Pulls data from Core Data.
    func fetchData() {
        let request = NSFetchRequest<Company>(entityName: "Company")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Company.id, ascending: false)]
        
        do {
            let companies = try container.viewContext.fetch(request)
            waitCompanies = []
            approveCompanies = []
            notApproveCompanies = []
            
            DispatchQueue.main.async {
                for company in companies {                    
                    if let work = company.work {
                        switch work.approve {
                        case "Wait":
                            self.waitCompanies.append(company)
                        case "Approve":
                            self.approveCompanies.append(company)
                        case "NotApprove":
                            self.notApproveCompanies.append(company)
                        default:
                            print("Not found any information!")
                        }
                    }
                }
                
                self.companies = companies
            }
            
            
        } catch {
            print("Veriler alınamadı: \(error.localizedDescription)")
        }
        
    }
    
    // Adds Data to Core Data.
    func create() {
        save()
        fetchData()
    }
    
    // Update Data to Core Data.
    func update() {
        save()
        fetchData()
    }
    
    // Delete Data to Core Data.
    func delete(_ company: Company) {
        container.viewContext.delete(company)
        fetchData()
        save()
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
    
}
