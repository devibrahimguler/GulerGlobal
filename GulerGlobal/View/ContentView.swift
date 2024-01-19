//
//  ContentView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
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

struct TestContentView: View {
    
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Company.self)
        } catch {
            fatalError("Failed to create ModelContainer for Game.")
        }
    }
    
    var body: some View {
        ContentView(modelContext: container.mainContext)
            .modelContainer(container)
    }
}

#Preview {
    TestContentView()
}
