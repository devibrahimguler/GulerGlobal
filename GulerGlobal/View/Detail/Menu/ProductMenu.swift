//
//  ProductMenu.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 28.10.2025.
//

import SwiftUI

struct ProductMenu: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var productVM: ProductViewModel
    @Binding var isEdit: Bool
    @Binding var formTitle: FormTitle
    @Binding var openMenu: Bool
    
    var dateConfig: DateConfig
    var product: Product
    var companyId: String
    var workId: String?
    var isSupplier: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Button {
                withAnimation(.spring) {
                    productVM.updateProductDetails(with: product)
                    formTitle = .none
                    openMenu = false
                    isEdit.toggle()
                }
            } label: {
                if isEdit {
                    Label("İptal", systemImage: "pencil.slash")
                } else {
                    Label("Düzenle", systemImage: "square.and.pencil")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
            .padding(.horizontal, 20)
            
            if isEdit {
                Button {
                    withAnimation(.spring) {
                        let updateArea = [
                            "productName": productVM.productDetails.name.trim(),
                            "quantity": productVM.productDetails.quantity.toDouble(),
                            "unitPrice": productVM.productDetails.unitPrice.toDouble(),
                            "purchased": configToDate(dateConfig)
                        ]
                        productVM.updateProduct(companyId: companyId, productId: product.id, updateArea: updateArea)
                        
                        formTitle = .none
                        openMenu = false
                        isEdit.toggle()
                        
                        dismiss()
                    }
                    
                } label: {
                    Label("Kaydet", systemImage: "pencil.line")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 20)
            }
            
        }
    }
}
