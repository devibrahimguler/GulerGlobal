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
    var color: Color
    
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
        .background(color.gradient)
    }
    
    private var companyInitials: some View {
        Text(String(companyName.prefix(1)))
            .font(.title)
            .foregroundStyle(.yazi)
            .frame(width: 45, height: 45)
            .background(Color.iRenk.gradient, in: Circle())
    }
    
    private var companyDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(companyName)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text(work.workName)
                .font(.caption)
                .foregroundStyle(.white)
        }
    }
    
    private var workDetails: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("P-\(work.id)")
                .font(.caption2)
                .fontWeight(.black)
                .foregroundStyle(.white)
            
            Label {
                Text("\((isApprove ? work.remainingBalance : work.totalCost).customDouble())")
            } icon: {
                Image(systemName: "turkishlirasign")
            }
            .font(.headline)
            .fontWeight(.black)
            .foregroundStyle(isApprove ? .red : .uRenk)
        }
    }
}

struct TestCard: View {
    let tuple = example_TupleModel
    
    var body: some View {
        WorkCard(companyName: tuple.company.companyName,
                 work: tuple.work,
                 isApprove: false,
                 color: .bRenk)
        .preferredColorScheme(.light)
    }
}

#Preview {
    TestCard()
}
