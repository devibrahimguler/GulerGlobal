//
//  WorkCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.02.2024.
//

import SwiftUI

struct WorkCard: View {
    var companyName: String
    var work: Work
    var isApprove: Bool
    
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
    }
    
    private var companyInitials: some View {
        Text(String(companyName.prefix(1)))
            .font(.title)
            .foregroundStyle(.isText)
            .frame(width: 45, height: 45)
            .background(Color.isSkyBlue.gradient, in: Circle())
    }
    
    private var companyDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(companyName)
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
                Text("\((isApprove ? work.remainingBalance : work.totalCost).customDouble())")
            } icon: {
                Image(systemName: "turkishlirasign")
            }
            .font(.headline)
            .fontWeight(.black)
            .foregroundStyle(isApprove ? .red : .isGreen)
        }
    }
}

struct TestCard: View {
    let tuple = example_TupleModel
    
    var body: some View {
        WorkCard(companyName: tuple.company.companyName,
                 work: tuple.work,
                 isApprove: false)
        .preferredColorScheme(.light)
    }
}

#Preview {
    TestCard()
}
