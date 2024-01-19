//
//  GulerGlobalApp.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI
import SwiftData

@main
struct GulerGlobalApp: App {
    
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Company.self)
        } catch {
            fatalError("Failed to create ModelContainer for Game.")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
}
