//
//  Card.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 20.01.2024.
//

import SwiftUI

struct Card: View {
    
    var company: Company
    var works: [Work]?
    
    var body: some View {
        ZStack(alignment: .top) {
            Text(company.name)
                .font(.title3)
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5).stroke(style: .init(lineWidth: 1))
                        .fill(.black.opacity(0.5))
                        .shadow(color: .black, radius: 10, y: 5)
                }
                .zIndex(1)
            
            VStack {
                VStack(alignment: .leading) {
                    
                    WorkInfo(text: "FİRMA AÇIKLAMA", desc: company.desc, alignment: .leading)
                    
                    Divider()
                    
                    WorkInfo(text: "FİRMA ADRESS", desc: company.adress, alignment: .leading)
                    
                    Divider()
                    
                    WorkInfo(text: "FİRMA TELFON", desc: company.phone, alignment: .leading)
                    
                }
                .padding(.vertical , 20)
                .padding(.horizontal)
                .background(.BG)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                
                WorkInfo(text: "Projeler", desc: "\(works?.count ?? 0)", alignment: .center)
                    .padding(10)
                    .background(.BG)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                
                
                WorkCard(works: works)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
            .padding(10)
            .background(.gray.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(10)
            
        }
        .fontDesign(.monospaced)
        .fontWeight(.bold)
    }
}

#Preview {
    TestHome()
}
