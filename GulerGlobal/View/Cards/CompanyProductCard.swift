//
//  ProductCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 10.08.2024.
//

import SwiftUI

struct CompanyProductCard: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var companyProduct: CompanyProduct

    var totalPrice: Double {
        Double(companyProduct.quantity) * Double(companyProduct.price)
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    productInfoLabel(
                        title: companyProduct.name,
                        icon: Image(systemName: "character.textbox"))
                    
                    productInfoLabel(
                        title: companyProduct.date.getStringDate(.short),
                        fontSize: .caption2,
                        icon: Image(systemName: "calendar"))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    productInfoLabel(
                        title: "\(Int(companyProduct.quantity))",
                        icon: Image(systemName: "shippingbox.fill"))
                    
                    productInfoLabel(
                        title: companyProduct.price.customDouble(),
                        icon:Image(systemName: "turkishlirasign"))
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 13)
        }
        .frame(maxWidth: .infinity)
    }
    
    // Helper method to create labels
    @ViewBuilder
    private func productInfoLabel(title: String, fontSize: Font = .callout, icon: some View) -> some View {
        Label {
            Text(title)
                .font(fontSize)
                .fontWeight(.bold)
        } icon: {
            icon
        }
        .lineLimit(1)
    }
}


struct Test_CompanyProductCard: View {
    var body: some View {
        CompanyProductCard(companyProduct: example_CompanyProduct)
    }
}

#Preview {
    Test_CompanyProductCard()
}
