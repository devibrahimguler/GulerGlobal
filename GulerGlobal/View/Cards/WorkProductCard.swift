//
//  WorkProductCard.swift
//  GulerGlobal
//
//  Created by ibrahim on 7.12.2025.
//

import SwiftUI

struct WorkProductCard: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    var workProduct: WorkProduct
    
    var companyProduct: CompanyProduct {
        viewModel.getCompanyProductById(self.workProduct.productId)
    }
    var companyName: String {
        viewModel.getCompanyById(companyProduct.companyId).name
    }
    var totalPrice: Double {
        Double(workProduct.quantity) * Double(companyProduct.price)
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            // Suggestion Title
            Text(companyName)
                .padding(5)
                .frame(maxWidth: .infinity)
                .font(.callout)
                .fontWeight(.bold)
             
            
            // Product Details
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
                        title: "\(Int(workProduct.quantity))",
                        icon: Image(systemName: "shippingbox.fill"))
                    
                    productInfoLabel(
                        title: companyProduct.price.customDouble(),
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

struct Test_WorkProductCard: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        WorkProductCard(workProduct: example_WorkProduct)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_WorkProductCard()
}
