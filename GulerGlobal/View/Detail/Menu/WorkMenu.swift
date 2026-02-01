//
//  WorkMenu.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 28.10.2025.
//

import SwiftUI

struct WorkMenu: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: MainViewModel
    @Binding var isEdit: Bool
    @Binding var formTitle: FormTitle
    @Binding var openMenu: Bool
    @Binding var hiddingAnimation: Bool
    @Binding var startConfig: DateConfig
    @Binding var endConfig: DateConfig
    
    var tuple: TupleModel
    
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
                        viewModel.workDetails.companyId = tuple.work.companyId
                        viewModel.workDetails.left = "\(tuple.work.left)"
                        viewModel.workDetails.status = tuple.work.status
                        viewModel.workDetails.startDate = startConfig.configToDate()
                        viewModel.workDetails.endDate = endConfig.configToDate()
                        
                        viewModel.workUpdate(
                            workId: tuple.work.id,
                            workDetails: viewModel.workDetails
                        )
                        
                        formTitle = .none
                        openMenu = false
                        isEdit.toggle()
                    }
                }
            }
            else
            {
                if tuple.work.status == .approved {
                    SettingButton(settingType: .finishedWork) {
                        withAnimation(.snappy) {
                            viewModel.workDetails.companyId = tuple.work.companyId
                            viewModel.workDetails.left = "\(tuple.work.left)"
                            viewModel.workDetails.status = .finished
                            viewModel.workDetails.startDate = startConfig.configToDate()
                            viewModel.workDetails.endDate = endConfig.configToDate()
                            
                            viewModel.workUpdate(
                                workId: tuple.work.id,
                                workDetails: viewModel.workDetails
                            )
                            
                            dismiss()
                        }
                    }
                    
                    SettingNavigation(
                        content:
                            WorkProductEntry(workId: tuple.work.id)
                            .environmentObject(viewModel),
                        settingType: .addProduct
                    )
                }
            }
        }
        .padding(20)
    }
}

