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
                    .foregroundStyle(.bRenk.gradient)
                }
            }
            .padding(10)
            .background(.background, in: .rect(cornerRadius: 20))
            
            VStack() {
                HStack {
                    
                    NavigationButton(
                        content:
                            FinishedBidView()
                            .environmentObject(viewModel),
                        buttonType: .finished)
                    
                    NavigationButton(
                        content:
                            RejectedView()
                            .environmentObject(viewModel),
                        buttonType: .cancel)
                    
                    NavigationButton(
                        content:
                            CurrentsView()
                            .environmentObject(viewModel),
                        buttonType: .currents)
                    
                    
                    
                }
                
                HStack {
                    
                    NavigationButton(
                        content:
                            DebsView()
                            .environmentObject(viewModel),
                        buttonType: .debs)
                    
                    NavigationButton(
                        content:
                            VStack { Text("Yakında!") },
                        buttonType: .soon)
                    
                    
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(.background, in: .rect(cornerRadius: 20))
            
            Spacer()
            
        }
        .padding(.horizontal, 10)
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2) )
        
    }
}

#Preview {
    ContentView()
}
