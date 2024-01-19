//
//  Home.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI
import SwiftData

struct Home: View {
    @State private var searchText = ""
    @State private var isAddWork = false
    
    @Binding var companyViewModel: CompanyViewModel
    
    var body: some View {
        
        NavigationStack {
            VStack {
                ForEach(companyViewModel.companies ?? [], id:\.self) { company in
                    Card(company: company)
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
            
        }
        .searchable(text: $searchText)
        .fullScreenCover(isPresented: $isAddWork) {
            Note(companyViewModel: $companyViewModel, isAddWork: $isAddWork)
        }
    }
    
    @ViewBuilder
    func Card(company: Company) -> some View {
        ZStack(alignment: .top) {
            Text(company.name)
                .font(.largeTitle)
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5).stroke(style: .init(lineWidth: 1))
                        .fill(.black.opacity(0.5))
                        .shadow(color: .black, radius: 10, y: 5)
                }
                .zIndex(1)
            
            VStack(alignment: .leading) {
                
                WorkInfo(text: "İŞ İSMİ", desc: company.work.name)
                
                Divider()
                
                Text("İŞ AÇIKLAMA")
                    .foregroundStyle(.gray)
                
                Text(company.work.desc)
                    .padding(2)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .padding(.vertical , 30)
            .padding(.horizontal)
            .background(.BG)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(20)
            .padding(.top, 10)
            
   
            
        }
        .fontDesign(.monospaced)
        .fontWeight(.bold)
        
        
    }
    
}
struct TestGapHome : View {
    
    @State private var companyViewModel: CompanyViewModel
    
    init(modelContext: ModelContext) {
        UITabBar.appearance().isHidden = true
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
