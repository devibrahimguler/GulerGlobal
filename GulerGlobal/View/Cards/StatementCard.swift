//
//  StatementsCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.10.2025.
//

import SwiftUI

struct StatementCard: View {
    
    var statement: Statement
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            
            Label {
                Text("\(statement.amount.customDouble())")
            } icon: {
                Image(systemName: "turkishlirasign")
            }
            .font(.title3)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Label {
                Text("\(statement.date.getStringDate(.long))")
            } icon: {
                Image(systemName: "calendar")
            }
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(.gray)
            
        }
        .padding()
        .background(statement.status == .input || statement.status == .lend ? .green.opacity(0.5) : .red.opacity(0.5))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StatementCard(statement: example_Statement)
}
