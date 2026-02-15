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
            
            SettingButton(settingType: isEdit ? .cancel : .edit) {
                withAnimation(.spring) {
                    formTitle = .none
                    openMenu = false
                    isEdit.toggle()
                }
            }
            
            if isEdit {
                SettingButton(settingType: .save) {
                    withAnimation(.spring) {
                        
                        viewModel.companyProductVM.companyProductDetails.date = dateConfig.configToDate()
                        
                        viewModel.companyProductVM.update(productId: product.id, companyProductDetails: viewModel.companyProductVM.companyProductDetails, setLoading: viewModel.setLoading)
                        
                        formTitle = .none
                        openMenu = false
                        isEdit.toggle()
                    }
                }
            }
        }
        .padding(20)
    }
}
