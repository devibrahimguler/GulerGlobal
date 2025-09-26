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
    var color: Color
    var body: some View {
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(1)
        .fontWeight(.semibold)
        .padding(10)
        .background(color.gradient)
    }
}

struct TestCompanyCard: View {
    var body: some View {
        CompanyCard (
            company: example_TupleModel.company,
            color: .isCream
        )
    }
}

#Preview {
    TestCompanyCard()
}
