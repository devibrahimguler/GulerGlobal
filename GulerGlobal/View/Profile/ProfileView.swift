//
//  ProfileView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 30.01.2024.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment: .center) {
                Image("icon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 100, style: .continuous))
                
                Text("\(viewModel.authService.getUserName ?? "GulerMetSan")")
                    .font(.headline)
                    .fontWeight(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            
            
            NavigationList()
            
        }
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2) )
        
    }
    
    @ViewBuilder
    func NavigationList() -> some View {
        VStack {
            NavigationButton(
                content:
                    FinishedBidView()
                    .environmentObject(viewModel)
                    .toolbar(.hidden, for: .tabBar),
                buttonType: .finished,
                description: "\(viewModel.workVM.works.filter({ $0.status == .finished }).count ) adet Proje var")
            
            NavigationButton(
                content:
                    RejectedView()
                    .environmentObject(viewModel)
                    .toolbar(.hidden, for: .tabBar),
                buttonType: .cancel,
                description: "\(viewModel.workVM.works.filter({ $0.status == .rejected }).count ) adet Proje var")
            
            NavigationButton(
                content:
                    CurrentView(viewModel: viewModel)
                    .environmentObject(viewModel)
                    .toolbar(.hidden, for: .tabBar),
                buttonType: .currents,
                description: "\(viewModel.companyVM.companies.filter({ $0.status == .current }).count ) adet Şirket var")
            
            NavigationButton(
                content:
                    SupplierView()
                    .environmentObject(viewModel)
                    .toolbar(.hidden, for: .tabBar),
                buttonType: .supplier,
                description: "\(viewModel.companyVM.companies.filter({ $0.status == .supplier }).count ) adet Şirket var")
            
            NavigationButton(
                content:
                    DebtView()
                    .environmentObject(viewModel)
                    .toolbar(.hidden, for: .tabBar),
                buttonType: .debt,
                description: "Borç Sayfası")
            
            NavigationButton(
                content:
                    VStack { Text("Yakında!") }
                    .toolbar(.hidden, for: .tabBar),
                buttonType: .soon,
                description: "Yakında")
        }
        .padding([.horizontal, .bottom], 20)
    }
}

struct Test_ProfileView: View {
    @StateObject private var viewModel = MainViewModel()
    var body: some View {
        ProfileView(viewModel: viewModel)
            .environmentObject(MainViewModel())
    }
}

#Preview {
    Test_ProfileView()
}
