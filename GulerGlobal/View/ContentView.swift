//
//  ContentView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        if viewModel.isPlaceHolder {
            CustomPlaceHolder()
        } else if viewModel.isConnected {
            MainView()
            .environmentObject(viewModel)
        } else {
            EntryView(userConnection: viewModel.userConnection, isPlaceHolder: $viewModel.isPlaceHolder, isConnected: $viewModel.isConnected)
                .environmentObject(viewModel)
            
        }
    }
}

#Preview {
    ContentView()
}
