//
//  OldPricesCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.10.2025.
//

import SwiftUI

struct OldPricesCard: View {
    
    var oldPrice: OldPrice
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            
            Label {
                Text("\(oldPrice.price.customDouble())")
            } icon: {
                Image(systemName: "turkishlirasign")
            }
            .font(.title3)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Label {
                Text("\(oldPrice.date.getStringDate(.long))")
            } icon: {
                Image(systemName: "calendar")
            }
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(.gray)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    OldPricesCard(oldPrice: example_OldPrice)
}
