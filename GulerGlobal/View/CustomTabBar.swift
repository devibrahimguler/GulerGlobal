//
//  CustomTabBar.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.07.2024.
//

import SwiftUI

struct CustomTabBar: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        NavigationView {
            TabView(
                selection: Binding(
                    get: { viewModel.activeTab },
                    set: { handleTabChange(to: $0)}
                )
            ) {
                HomeView()
                    .tag(TabValue.Home)
                    .toolbarBackground(.visible, for: .tabBar)
                
                BidView()
                    .tag(TabValue.Bid)
                    .toolbarBackground(.visible, for: .tabBar)
                
                ApprovedView()
                    .tag(TabValue.Approved)
                    .toolbarBackground(.visible, for: .tabBar)
                
                ProfileView()
                    .tag(TabValue.Profile)
                    .toolbarBackground(.visible, for: .tabBar)
            }
            .navigationBarHidden(true)
            .environmentObject(viewModel)
            .overlay(alignment: .bottom) {
                createAnimatedTabBar()
                    .opacity(viewModel.isTabBarHidden ? 0 : 1)
                    .animation(.snappy, value: viewModel.isTabBarHidden)
            }
            .ignoresSafeArea(.keyboard, edges: .all)
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Tab Change Handler
    private func handleTabChange(to newValue: TabValue) {
        viewModel.activeTab = newValue
        viewModel.tabAnimationTrigger = newValue
        
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            viewModel.tabAnimationTrigger = nil
        }
    }
    
    // MARK: - Animated Tab Bar
    @ViewBuilder
    private func createAnimatedTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(TabValue.allCases, id: \.rawValue) { tab in
                createTabItem(for: tab)
            }
        }
        .allowsHitTesting(false)
        .frame(height: 48)
    }
    
    // MARK: - Tab Item
    @ViewBuilder
    private func createTabItem(for tab: TabValue) -> some View {
        VStack(spacing: 4) {
            Image(systemName: tab.symbolImage)
                .font(.title3)
                .symbolVariant(.fill)
                .symbolEffect(
                    .bounce.byLayer.down,
                    options: .speed(2),
                    value: viewModel.tabAnimationTrigger == tab
                )
            
            Text(tab.rawValue)
                .font(.caption2)
                .foregroundStyle(viewModel.activeTab == tab ? .bRenk : .gray)
        }
        .foregroundColor(viewModel.activeTab == tab ? .bRenk : .gray)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}

enum TabValue: String, CaseIterable {
    case Home = "GulerMetSan"
    case Bid = "Teklifler"
    case Approved = "Mevcut İşler"
    case Profile = "Kullanıcı"
    
    var symbolImage: String {
        switch self {
        case .Home: "house"
        case .Bid: "rectangle.stack"
        case .Approved: "checkmark.rectangle.stack.fill"
        case .Profile: "person.fill"
        }
    }
}
