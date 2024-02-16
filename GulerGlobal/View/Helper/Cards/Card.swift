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
    var company: Company
    var isApprove: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack(spacing: 5) {
                Text(company.name ?? "")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .propartyTextdBack()
           
                
                Spacer()
                
                Text("P-\(company.work?.pNum ?? "")")
                    .font(.caption.bold())
                    .propartyTextdBack()
            }
            .foregroundStyle(.black)
            .padding(.horizontal, 30)
            .zIndex(1)
            
            
            VStack(alignment: .leading) {
                HStack {
                    WorkProperty(text: "Proje İsmi:", desc: "\(company.work?.name ?? "" )", alignment: .leading)
                    
                    Divider()
                    
                    WorkProperty(text: isApprove ? "Kalan:" : "Proje Fiyatı:", desc: "\(isApprove ? company.work?.accept?.remMoney ?? 0 : company.work?.price ?? 0 ) ₺", alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .padding(5)
                .padding(.top, 15)
         
                
            }
            .background(.BG)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: scheme == .light ? .black : .white ,radius: 1)
            .padding(15)
            
        }
        .frame(height: 120)
        .contentShape(Rectangle())

   
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}

