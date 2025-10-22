//
//  ProfileView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 30.01.2024.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .center) {
                HStack {
                    Image("icon")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                    
                    Spacer()
                    
                    VStack {
                        Text("\(viewModel.authService.getUserName ?? "")")
                            .font(.headline)
                            .fontWeight(.black)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.smooth) {
                            viewModel.isLoadingPlaceholder = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.authService.logout { result in
                                    switch result {
                                    case .success(_):
                                        viewModel.isUserConnected = false
                                        viewModel.isLoadingPlaceholder = false
                                        
                                    case .failure(_):
                                        viewModel.isUserConnected = true
                                        viewModel.isLoadingPlaceholder = false
                                        
                                    }
                                }
                            }
                        }
                    } label: {
                        VStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Çıkış Yap")
                        }
                    }
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundStyle(Color.accentColor)
                }
            }
            .padding(10)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30))
            
            VStack() {
                HStack {
                    NavigationButton(
                        content:
                            FinishedBidView()
                            .environmentObject(viewModel)
                            .toolbar(.hidden, for: .tabBar),
                        buttonType: .finished)
                    
                    NavigationButton(
                        content:
                            RejectedView()
                            .environmentObject(viewModel)
                            .toolbar(.hidden, for: .tabBar),
                        buttonType: .cancel)
                    
                    NavigationButton(
                        content:
                            CurrentView()
                            .environmentObject(viewModel)
                            .toolbar(.hidden, for: .tabBar),
                        buttonType: .currents)
                }
                
                HStack {
                    NavigationButton(
                        content:
                            SupplierView()
                            .environmentObject(viewModel)
                            .toolbar(.hidden, for: .tabBar),
                        buttonType: .supplier)
                    
                    NavigationButton(
                        content:
                            DebtView()
                            .environmentObject(viewModel)
                            .toolbar(.hidden, for: .tabBar),
                        buttonType: .debt)
                    
                    NavigationButton(
                        content:
                            VStack { Text("Yakında!") }
                            .toolbar(.hidden, for: .tabBar),
                        buttonType: .soon)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30))
            
            Spacer()
            
        }
        .padding(.horizontal, 10)
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2) )
        
    }
}

struct Test_ProfileView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        ProfileView()
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_ProfileView()
}
