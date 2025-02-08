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
    @State private var isReset: Bool = false
    
    var body: some View {
        BaseList(isEmpty: viewModel.companyList.isEmpty) {
            ForEach(viewModel.companyList, id: \.self) { company in
                NavigationLink {
                    CompanyDetailView(company: company)
                        .environmentObject(viewModel)
                } label: {
                    SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                        CompanyCard(company: company, color: .bRenk)
                    } actions: {
                        Action(tint: .red, icon: "trash.fill") {
                            
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(lineWidth: 1)
                            .fill(Color.iRenk.gradient)
                    }
                }
            }
        }
        .toolbar(content: {
            NavigationLink {
                CompanyEntryView(isAddCurrent: $isAddCurrent)
            } label: {
                Text("Ekle")
                    .font(.system(size: 14, weight: .black, design: .monospaced))
                    .foregroundStyle(.green)
            }
        })
        .navigationTitle("Cariler")
    }
}

#Preview {
    ContentView()
}
