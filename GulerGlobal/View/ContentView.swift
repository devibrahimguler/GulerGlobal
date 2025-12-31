//
//  ContentView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoadingPlaceholder {
                CustomPlaceHolder()
                    .viewCenter()
                    .ignoresSafeArea()
                    .background(Color.black)
            } else if viewModel.isUserConnected {
                CustomTabBar()
            } else {
                EntryView()
                
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
