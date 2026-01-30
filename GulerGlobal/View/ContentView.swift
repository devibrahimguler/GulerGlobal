//
//  ContentView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = EntryViewModel()
    
    var body: some View {
        if viewModel.isLoading {
            CustomPlaceHolder()
                .viewCenter()
                .ignoresSafeArea()
                .background(Color.black)
        } else if viewModel.isConnected {
            MainView()
        } else {
            EntryView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    ContentView()
}
