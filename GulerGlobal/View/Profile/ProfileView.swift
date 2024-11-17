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
        NavigationView {
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
                            Text("Hoş Geldiniz!")
                            
                            Text("\(viewModel.userConnection.getUserName ?? "")")
                                .foregroundStyle(.red)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.smooth) {
                                viewModel.isPlaceHolder = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    viewModel.userConnection.logout { result in
                                        switch result {
                                        case .success(_):
                                            viewModel.isConnected = false
                                            viewModel.isPlaceHolder = false
                                            
                                        case .failure(_):
                                            viewModel.isConnected = true
                                            viewModel.isPlaceHolder = false
                                            
                                        }
                                    }
                                }
                            }
                        } label: {
                            VStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                
                                Text("Çıkış Yap")
                                    .font(.system(size: 12, weight: .black))
                            }
                        }
                        
                        
                        
                    }
                }
                .padding(10)
                .background(.background, in: .rect(cornerRadius: 20))
                
                VStack() {
                    HStack {
                        
                        HomeScreenButton(
                            content:
                                FinishedBidView()
                                .environmentObject(viewModel)
                                .onAppear {
                                    UITabBar.changeTabBarState(shouldHide: true)
                                },
                            buttonType: .finished)
                        
                        HomeScreenButton(
                            content:
                                UnapprovedView()
                                .environmentObject(viewModel)
                                .onAppear {
                                    UITabBar.changeTabBarState(shouldHide: true)
                                },
                            buttonType: .cancel)
                        
                        HomeScreenButton(
                            content:
                                CompaniesView()
                                .environmentObject(viewModel)
                                .onAppear {
                                    UITabBar.changeTabBarState(shouldHide: true)
                                },
                            buttonType: .companies)
                        
                        
                    }
                    .foregroundStyle(Color.accentColor)
                    .padding(.horizontal, 10)
                    
                    HStack {
                        
                        HomeScreenButton(
                            content:
                                CurrentsView()
                                .environmentObject(viewModel)
                                .onAppear {
                                    UITabBar.changeTabBarState(shouldHide: true)
                                },
                            buttonType: .currents)
                        
                        HomeScreenButton(
                            content:
                                DebsView()
                                .environmentObject(viewModel)
                                .onAppear {
                                    UITabBar.changeTabBarState(shouldHide: true)
                                },
                            buttonType: .debs)
                        
                        HomeScreenButton(
                            content:
                                VStack { Text("Yakında!") }
                                .onAppear {
                                    UITabBar.changeTabBarState(shouldHide: true)
                                },
                            buttonType: .soon)
                        
                        
                    }
                    .foregroundStyle(Color.accentColor)
                    .padding(.horizontal, 10)
                }
                .padding(.vertical, 10)

                .background(.background, in: .rect(cornerRadius: 20))
                .padding(.horizontal, 10)
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2) )
            .font(.system(size: 20, weight: .black, design: .monospaced))
            .onAppear {
                UITabBar.changeTabBarState(shouldHide: false)
            }
        }
        
    }
}

#Preview {
    ContentView()
}
