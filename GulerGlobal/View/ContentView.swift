//
//  ContentView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = EntryViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                CustomPlaceHolder()
                    .viewCenter()
                    .ignoresSafeArea()
                    .background(Color.black)
            } else if viewModel.isConnected {
                CustomTabBar()
            } else {
                EntryView()
                    .environmentObject(viewModel)
                
            }
        }
    }
}

#Preview {
    ContentView()
}
