//
//  WorkCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.02.2024.
//

import SwiftUI

struct WorkCard: View {
    var company: Company
    var work: Work
    
    var body: some View {
        HStack(spacing: 12) {
            companyInitials
            companyDetails
            Spacer()
            workDetails
        }
        .lineLimit(1)
        .fontWeight(.semibold)
        .padding(13)
    }
    
    private var companyInitials: some View {
        Text(String(company.companyName.prefix(1)))
            .font(.title)
            .foregroundStyle(.black.gradient)
            .frame(width: 45, height: 45)
            .background(Color.isSkyBlue.gradient, in: Circle())
    }
    
    private var companyDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(company.companyName)
                .fontWeight(.bold)
                .foregroundStyle(.isText)
            
            Text(work.workName)
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
    
    private var workDetails: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("P-\(work.id)")
                .font(.caption2)
                .fontWeight(.black)
                .foregroundStyle(.isText)
            
            Label {
                Text(work.approve == .approved ? "\(work.remainingBalance.customDouble())" : "\(work.totalCost.customDouble())")
            } icon: {
                Image(systemName: "turkishlirasign")
            }
            .font(.headline)
            .fontWeight(.black)
            .foregroundStyle(work.approve == .approved ? .red.opacity(0.7) : .blue.opacity(0.7))
        }
    }
}

struct TestCard: View {
    let tuple = example_TupleModel
    
    var body: some View {
        WorkCard(company: tuple.company,
                 work: tuple.work)
        .preferredColorScheme(.light)
    }
}

#Preview {
    TestCard()
}
