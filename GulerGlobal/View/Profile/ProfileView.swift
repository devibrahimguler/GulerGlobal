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
    @Binding var selectedCompany: Company?
    @Binding var tab: Tabs
    @Binding var edit: Edit
    
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
                            
                            Text("\(viewModel.userConnection.getUserName ?? "") Bey")
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
                .background(.hWhite)
                .clipShape(RoundedCorner(radius: 10))
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .center)
                .shadow(color: colorScheme == .dark ? .white : .black ,radius: 5)
                
                HStack {
                    NavigationLink {
                        FinishedBidView(tab: $tab, edit: $edit)
                            .environmentObject(viewModel)
                            .onAppear {
                                UITabBar.changeTabBarState(shouldHide: true)
                            }
                    } label: {
                        VStack {
                            Image("finished")
                                .resizable()
                                .aspectRatio(contentMode: .fit)

                            Text("Bitmiş")
                                .font(.system(size: 12, weight: .black))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(10)
                    .background(.hWhite)
                    .clipShape(RoundedCorner(radius: 10))
                    .overlay {
                        RoundedCorner(radius: 10)
                            .stroke(style: .init(lineWidth: 1))
                            .fill(.lGray)
                    }
                    .shadow(color: colorScheme == .dark ? .white : .black ,radius: 5)
                    
                    NavigationLink {
                        UnapprovedView(tab: $tab, edit: $edit)
                            .environmentObject(viewModel)
                            .onAppear {
                                UITabBar.changeTabBarState(shouldHide: true)
                            }
                    } label: {
                        VStack {
                            Image("cancel")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            Text("İptal")
                                .font(.system(size: 12, weight: .black))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(10)
                    .background(.hWhite)
                    .clipShape(RoundedCorner(radius: 10))
                    .overlay {
                        RoundedCorner(radius: 10)
                            .stroke(style: .init(lineWidth: 1))
                            .fill(.lGray)
                    }
                    .shadow(color: colorScheme == .dark ? .white : .black ,radius: 5)
                    
                    
                    NavigationLink {
                        
                    } label: {
                        VStack {
                            Image(systemName: "circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            Text("Yakında !")
                                .font(.system(size: 12, weight: .black))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(10)
                    .background(.hWhite)
                    .clipShape(RoundedCorner(radius: 10))
                    .overlay {
                        RoundedCorner(radius: 10)
                            .stroke(style: .init(lineWidth: 1))
                            .fill(.lGray)
                    }
                    .shadow(color: colorScheme == .dark ? .white : .black ,radius: 5)
                    
                }
                .foregroundStyle(.bBlue)
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity, alignment: .center)
                


                Spacer()
                
            }
            .font(.system(size: 20, weight: .black, design: .monospaced))
            .foregroundStyle(.black)
            .onAppear {
                UITabBar.changeTabBarState(shouldHide: false)
            }
        }
    }
}

#Preview {
    ContentView()
}
