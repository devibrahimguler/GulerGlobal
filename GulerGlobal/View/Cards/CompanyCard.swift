//
//  CompanyCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 29.09.2024.
//

import SwiftUI

struct CompanyCard: View {
    @Environment(\.colorScheme) var scheme
    var company: Company
    var body: some View {
        HStack(spacing: 12) {
            companyInitials
            
            VStack(alignment: .leading, spacing: 5) {
                
                Label {
                    Text("\(company.companyName)")
                        .font(.headline)
                        .fontWeight(.bold)
                } icon: {
                    Image(systemName: "character.textbox")
                }
                .foregroundStyle(.isText)
                .lineLimit(1)
                
                Label {
                    Text("\(company.companyAddress)")
                        .font(.caption)
                        .fontWeight(.bold)
                } icon: {
                    Image(systemName: "mappin.square")
                }
                .foregroundStyle(.isSilver)
                .lineLimit(1)
            }
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(1)
        .fontWeight(.semibold)
        .padding(15)
        .background(scheme == .dark ? .black : .white)
        .clipShape(.rect(cornerRadius: 30, style: .continuous))
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
    }
    
    private var companyInitials: some View {
        Text(String(company.companyName.prefix(1)))
            .font(.title)
            .foregroundStyle(.black.gradient)
            .frame(width: 45, height: 45)
            .background(Color.isSkyBlue.gradient, in: Circle())
    }
}

struct TestCompanyCard: View {
    var body: some View {
        CompanyCard (
            company: example_TupleModel.company
        )
    }
}

#Preview {
    TestCompanyCard()
}
