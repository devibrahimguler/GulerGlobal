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
            companyDetails
            
            Spacer()
        }
        .lineLimit(1)
        .fontWeight(.semibold)
        .padding(13)
    }
    
    private var companyInitials: some View {
        Text(String(company.name.prefix(1)))
            .font(.title)
            .foregroundStyle(.accent.gradient)
            .frame(width: 50, height: 50)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 25))
    }
    
    private var companyDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Label {
                Text("\(company.name)")
                    .font(.headline)
                    .fontWeight(.bold)
            } icon: {
                Image(systemName: "character.textbox")
            }
            .fontWeight(.bold)
            .foregroundStyle(.isText)
            .lineLimit(1)
            
            Label {
                Text("\(company.address)")
                    .font(.caption)
                    .fontWeight(.bold)
            } icon: {
                Image(systemName: "mappin.square")
            }
            .foregroundStyle(.gray)
            .lineLimit(1)
        }
        
    }
}

struct Test_CompanyCard: View {
    var body: some View {
        CompanyCard (
            company: example_TupleModel.company
        )
    }
}

#Preview {
    Test_CompanyCard()
}

