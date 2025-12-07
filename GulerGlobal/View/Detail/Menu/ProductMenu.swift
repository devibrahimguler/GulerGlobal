//
//  ProductMenu.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 28.10.2025.
//

import SwiftUI

struct ProductMenu: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: MainViewModel
    @Binding var isEdit: Bool
    @Binding var formTitle: FormTitle
    @Binding var openMenu: Bool
    
    var dateConfig: DateConfig
    var product: CompanyProduct
    var companyId: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Button {
                withAnimation(.spring) {
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
                        guard
                            viewModel.companyProductDetails.name != "",
                            viewModel.companyProductDetails.quantity != "",
                            viewModel.companyProductDetails.price != ""
                        else { return }
                        
                        let updateArea = [
                            "name": viewModel.companyProductDetails.name.trim(),
                            "quantity": viewModel.companyProductDetails.quantity.toDouble(),
                            "price": viewModel.companyProductDetails.price.toDouble(),
                            "date": configToDate(dateConfig)
                        ]
                        
                        viewModel.companyProductUpdate(productId: product.id, updateArea: updateArea)
                        
                        formTitle = .none
                        openMenu = false
                        isEdit.toggle()
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
