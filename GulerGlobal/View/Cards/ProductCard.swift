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
    var isSupplier: Bool
    
    var body: some View {
        let totalPrice = Double(product.quantity) * Double(product.unitPrice)
        
        VStack(spacing: 0) {
            // Suggestion Title
            if !isSupplier {
                Text(product.supplier)
                    .padding(5)
                    .frame(maxWidth: .infinity)
                    .font(.callout)
                    .fontWeight(.bold)
            }
             
            
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
                        title: "\(Int(product.quantity))",
                        icon: Image(systemName: "shippingbox.fill"))
                    
                    productInfoLabel(
                        title: product.unitPrice.customDouble(),
                        icon:Image(systemName: "turkishlirasign"))
                    
                    if !isSupplier {
                        productInfoLabel(
                            title: totalPrice.customDouble(),
                            icon: HStack(spacing: 2) {
                                Image(systemName: "shippingbox.fill")
                                Image(systemName: "plus")
                                Image(systemName: "turkishlirasign")
                            })
                    }
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


struct TestProductCard: View {
    var pro: Product = example_Product
    
    var body: some View {
        ProductCard(product: pro, isSupplier: false)
    }
}

#Preview {
    TestProductCard()
}
