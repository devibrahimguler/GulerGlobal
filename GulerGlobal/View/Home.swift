//
//  Home.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI
import SwiftData

struct Home: View {
    @State private var isAddWork = false
    
    @Binding var companyViewModel: CompanyViewModel
    
    var body: some View {
        
        NavigationStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                     ForEach(companyViewModel.companies ?? [], id:\.self) { company in
      
                         let works = companyViewModel.fetchCompanyWorks(name: company.name)
                         Card(company: company, works: works)
                     }
                }
            }
            .toolbar {
                Button {
                    withAnimation(.snappy) {
                        isAddWork = true
                    }
                } label: {
                    Text("İş Ekle")
                        .font(.headline)
                        .padding(10)
                    
                }
                
            }
            .navigationTitle("GulerGlobal")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .fullScreenCover(isPresented: $isAddWork) {
            Note(companyViewModel: $companyViewModel, isAddWork: $isAddWork)
        }
    }
}
struct TestGapHome : View {
    
    @State private var companyViewModel: CompanyViewModel
    
    init(modelContext: ModelContext) {
        UITabBar.appearance().isHidden = true
        do {
            try modelContext.delete(model: Company.self)
        } catch {
            print("Fetch failed")
        }
      
        let testCompany = [
            Company(name: "Şirket İsmi", desc: "Şirket Açıklaması", adress: "Şirket Adresi", phone: "5541701635", work: Work(name: "İş İsmi", desc: "İş Açıklaması", price: 1000, recMoney: 500, remMoney: 500, stTime: .now, fnTime: .now)),
            Company(name: "Şirket İsmi", desc: "Şirket Açıklaması 2", adress: "Şirket Adresi", phone: "5541701635", work: Work(name: "İş İsmi 2", desc: "İş Açıklaması 2", price: 1000, recMoney: 500, remMoney: 500, stTime: .now, fnTime: .now)),
            Company(name: "Şirket İsmi 2", desc: "Şirket Açıklaması 2", adress: "Şirket Adresi 2", phone: "5541701635", work: Work(name: "İş İsmi", desc: "İş Açıklaması", price: 1000, recMoney: 500, remMoney: 500, stTime: .now, fnTime: .now)),
            Company(name: "Şirket İsmi 3", desc: "Şirket Açıklaması 3", adress: "Şirket Adresi 3", phone: "5541701635", work: Work(name: "İş İsmi", desc: "İş Açıklaması", price: 1000, recMoney: 500, remMoney: 500, stTime: .now, fnTime: .now)),
            Company(name: "Şirket İsmi 4", desc: "Şirket Açıklaması 4", adress: "Şirket Adresi 4", phone: "5541701635", work: Work(name: "İş İsmi", desc: "İş Açıklaması", price: 1000, recMoney: 500, remMoney: 500, stTime: .now, fnTime: .now))]
        
        for i in testCompany {
            modelContext.insert(i)
        }
        let companyViewModel = CompanyViewModel(modelContext: modelContext)
        _companyViewModel = State(initialValue: companyViewModel)
    }
    
    var body: some View {
        Home(companyViewModel: $companyViewModel)
    }
}

struct TestHome : View {
    
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Company.self)
        } catch {
            fatalError("Failed to create ModelContainer for Game.")
        }
    }
    
    var body: some View {
        TestGapHome(modelContext: container.mainContext)
            .modelContainer(container)
    }
}

#Preview {
    TestHome()
}
