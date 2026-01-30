//
//  MainView.swift
//  GulerGlobal
//
//  Created by ibrahim on 30.01.2026.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                CustomPlaceHolder()
                    .viewCenter()
                    .ignoresSafeArea()
                    .background(Color.black)
            } else {
                CustomTabBar()
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    MainView()
}
