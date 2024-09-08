//
//  DetailCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 30.07.2024.
//

import SwiftUI

struct DetailCard: View {
    @Environment(\.colorScheme) var colorScheme
    
    var title: FormTitle
    var text: String
    var desc: String
    
    var color: Color = .hWhite
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Text(text.uppercased())
                .font(title == .companyName ? .system(size: 18, weight: .black, design: .rounded) : .system(size: 13, weight: .black, design: .rounded))
                .padding(2)
                .foregroundStyle(.blue)
                .background(.white)
                .clipShape(RoundedCorner(radius: 5, corners: [.topRight, .topLeft]))
                .overlay {
                    RoundedCorner(radius: 5, corners: [.topRight, .topLeft])
                        .stroke(style: .init(lineWidth: 1))
                        .fill(.gray)
                }
                .zIndex(1)
            
            Text(desc)
                .font(title == .companyName ? .system(size: 25, weight: .black, design: .rounded) : .system(size: 15, weight: .black, design: .rounded))
                .padding(.vertical, 5)
                .padding(.horizontal, 5)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(color == .red ? .white : .black)
                .background(color)
                .clipShape(RoundedCorner(radius: 5))
                .overlay {
                    RoundedCorner(radius: 5)
                        .stroke(style: .init(lineWidth: 1))
                        .fill(.gray)
                
                }
                .padding(.top,title == .companyName ? 26 : 20)
                .zIndex(0)
            
        }
        
        .padding(.vertical, 5)

    }
}

struct TestDetailCard: View {
    var body: some View {
        DetailCard(title: .companyName,text: "Firma Adı", desc: "Cerrahler Taş Dünyası")
    }
}
#Preview {
    TestDetailCard()
}
