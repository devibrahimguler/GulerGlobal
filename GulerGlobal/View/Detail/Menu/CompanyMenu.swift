//
//  CompanyMenu.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 28.10.2025.
//

import SwiftUI

struct CompanyMenu: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Binding var isEdit: Bool
    @Binding var formTitle: FormTitle
    @Binding var openMenu: Bool
    
    var company: Company
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
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
                        viewModel.companyVM.update(companyId: company.id, companyDetails: viewModel.companyVM.companyDetails, setLoading: viewModel.setLoading)
                        
                        formTitle = .none
                        openMenu = false
                        isEdit.toggle()
                    }
                }
            } else {
                if company.status == .supplier || company.status == .both {
                    SettingNavigation(
                        content:
                            CompanyProductEntry(company: company)
                            .environmentObject(viewModel),
                        settingType: .addProduct
                    )
                    
                    SettingNavigation(
                        content:
                            StatementEntry(status: .output, company: company)
                                .environmentObject(viewModel),
                        settingType: .output
                    )
                    
                    SettingNavigation(
                        content:
                            StatementEntry(status: .debt, company: company)
                                .environmentObject(viewModel),
                        settingType: .debt
                    )
                    
                }
                
                if company.status == .current || company.status == .both {
                    SettingNavigation(
                        content:
                            WorkEntry(company: company)
                                .environmentObject(viewModel),
                        settingType: .addWork
                    )
                    
                    SettingNavigation(
                        content:
                            StatementEntry(status: .input, company: company)
                                .environmentObject(viewModel),
                        settingType: .input
                    )

                    SettingNavigation(
                        content:
                            StatementEntry(status: .lend, company: company)
                                .environmentObject(viewModel),
                        settingType: .lend
                    )
                }
                
                
            }
        }
        .padding(20)
    }
}

