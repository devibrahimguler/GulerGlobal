//
//  ProductCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 10.08.2024.
//

import SwiftUI

struct ProductCard: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var product: Product
    
    var body: some View {
        let totalPrice = Double(product.quantity) * Double(product.unitPrice)
        
        VStack(spacing: 0) {
            // Suggestion Title
            Text(product.supplier)
                .padding(5)
                .frame(maxWidth: .infinity)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.isText)
                .background(Color.isSkyBlue)
             
            
            // Product Details
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    productInfoLabel(
                        title: product.productName,
                        icon: Image(systemName: "character.textbox"))
                    
                    productInfoLabel(
                        title: product.purchased.getStringDate(.short),
                        fontSize: .caption2,
                        icon: Image(systemName: "calendar"))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    productInfoLabel(
                        title: "\(product.quantity)",
                        icon: Image(systemName: "shippingbox.fill"))
                    
                    productInfoLabel(
                        title: product.unitPrice.customDouble(),
                        icon:Image(systemName: "turkishlirasign"))
                    productInfoLabel(
                        title: totalPrice.customDouble(),
                        icon: HStack(spacing: 2) {
                            Image(systemName: "shippingbox.fill")
                            Image(systemName: "plus")
                            Image(systemName: "turkishlirasign")
                        })
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 13)
            .background(
                product.isBought
                ? Color.isGreen.gradient
                : Color.isCream.gradient)
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
        .foregroundStyle(.isText)
        .foregroundStyle(.white)
        .lineLimit(1)
    }
}


struct TestProductCard: View {
    var pro: Product = example_Product
    
    var body: some View {
        ProductCard(product: pro)
    }
}

#Preview {
    TestProductCard()
}
