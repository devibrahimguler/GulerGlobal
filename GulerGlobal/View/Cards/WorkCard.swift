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
        .padding(10)
        .background(
            work.status == .finished ? .green.opacity(0.5) :
                work.status == .pending ? .yellow.opacity(0.5) :
                work.status == .rejected ? Color.isRed.opacity(0.5) : .clear
        )
    }
    
    private var companyInitials: some View {
        Text(String(company.name.prefix(1)))
            .font(.system(size: 40))
            .foregroundStyle(work.status == .rejected ? Color.white.gradient : Color.accent.gradient)
            .frame(width: 70, height: 70)
            .glassEffect(.regular, in: .rect(cornerRadius: 25))
    }
    
    private var companyDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(company.name)
                .fontWeight(.bold)
                .foregroundStyle(.isText)
            
            Text(work.name)
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
                Text(work.status == .approved ? "\(work.left.customDouble())" : "\(work.cost.customDouble())")
            } icon: {
                Image(systemName: "turkishlirasign")
            }
            .font(.headline)
            .fontWeight(.black)
            .foregroundStyle(work.status == .approved ? .red : work.status == .rejected ? .white : .accent)
        }
    }
}

struct Test_WorkCard: View {
    let tuple = example_TupleModel
    
    var body: some View {
        WorkCard(company: tuple.company,
                 work: tuple.work)
        .preferredColorScheme(.light)
    }
}

#Preview {
    Test_WorkCard()
}
