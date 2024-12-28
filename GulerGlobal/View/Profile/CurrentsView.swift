//
//  CurrentsView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 27.10.2024.
//

import SwiftUI

struct CurrentsView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isAddCurrent: Bool = false
    
    var body: some View {
        BaseList(title: "Cariler") {
            ForEach(viewModel.companies, id: \.self) { company in
                LazyVStack(spacing: 0) {
                    NavigationLink {
                        CompanyDetailView(company: company)
                            .environmentObject(viewModel)
                    } label: {
                        CompanyCard(company: company)
                    }
                }
            }
        }
        .blur(radius: isAddCurrent ? 5 : 0)
        .toolbar(content: {
            Button {
                withAnimation(.spring) {
                    isAddCurrent.toggle()
                }
            } label: {
                Text("EKLE")
                    .font(.system(size: 14, weight: .black, design: .monospaced))
                    .foregroundStyle(.green)
            }
        })
        .animation(.snappy, value: isAddCurrent)
        .sheet(isPresented: $isAddCurrent) {
            AddCurrentView(isAddCurrent: $isAddCurrent)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
                .presentationBackground(.thinMaterial)
                .presentationCornerRadius(10)
                .environmentObject(viewModel)
            
        }
        
    }
}

#Preview {
    ContentView()
}
