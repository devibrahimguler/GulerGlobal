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
                createPlaceHolderView()
            } else if viewModel.isUserConnected {
                CustomTabBar()
                    .environmentObject(viewModel)
            } else {
                createEntryView()
            }
        }
    }
    
    // MARK: - PlaceHolder View
    @ViewBuilder
    private func createPlaceHolderView() -> some View {
        CustomPlaceHolder()
            .viewCenter()
            .ignoresSafeArea()
            .background(Color.black)
    }
    
    // MARK: - Entry View
    @ViewBuilder
    private func createEntryView() -> some View {
        EntryView(
            userConnection: viewModel.authService,
            isPlaceHolder: $viewModel.isLoadingPlaceholder,
            isConnected: $viewModel.isUserConnected
        )
    }
}

#Preview {
    ContentView()
}
