//
//  Card.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.02.2024.
//

import SwiftUI

struct Card: View {
    @Environment(\.colorScheme) var scheme
    
    @Binding var selectedCompany: Company?
    @Binding var tab: Tabs
    var company: Company
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack(spacing: 5) {
                Text(company.name ?? "")
                    .font(.title3.bold())
                    .foregroundStyle(.solid)
                    .padding(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay {
                        RoundedRectangle(cornerRadius: 5).stroke(style: .init(lineWidth: 1))
                            .fill(.black.opacity(0.5))
                            .shadow(color: .black, radius: 10, y: 5)
                    }
                
                Spacer()
                
                Text("P-\(company.work?.pNum ?? "")")
                    .font(.caption.bold())
                    .foregroundStyle(.black)
                    .padding(.horizontal)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .overlay {
                        RoundedRectangle(cornerRadius: 2).stroke(style: .init(lineWidth: 1))
                            .fill(.blue.opacity(0.5))
                            .shadow(color: .blue, radius: 10, y: 5)
                    }
            }
            .padding(.horizontal, 30)
            .zIndex(1)
            
            
            VStack(alignment: .leading) {
                HStack {
                    WorkProperty(text: "Proje İsmi:", desc: "\(company.work?.name ?? "" )", alignment: .leading)
                    
                    Divider()
                    
                    WorkProperty(text: "Proje Fiyatı:", desc: "\(company.work?.price ?? 0) ₺", alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .padding(5)
                .padding(.top, 15)
         
                
            }
            .background(.BG)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(color: scheme == .light ? .black : .white ,radius: 5)
            .padding(20)
            
        }
        .frame(height: 120)
        .contentShape(Rectangle())

   
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}

