//
//  CompanyCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 29.09.2024.
//

import SwiftUI

struct CompanyCard: View {
    @Environment(\.colorScheme) var colorScheme
    var company: Company
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Text("\(company.name)")
                .lineLimit(1)
                .font(.system(size: 17, weight: .black, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.black)
            
            Text("\(company.address)")
                .lineLimit(1)
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundStyle(.gray)
        }
        .padding(10)
        .background(.hWhite)
        .clipShape(RoundedCorner(radius: 10))
        .overlay {
            RoundedCorner(radius: 10)
                .stroke(style: .init(lineWidth: 1))
                .fill(.lGray)
        }
        .shadow(color: colorScheme == .dark ? .white : .black ,radius: 2)
    }
}

struct TestCompanyCard: View {
    var body: some View {
        CompanyCard(company: .init(id: "0", name: "Firma İsmi", address: "Addresi", phone: "(554) 170 16 35", works: []))
    }
}

#Preview {
    TestCompanyCard()
}
