//
//  WorkMenu.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 28.10.2025.
//

import SwiftUI

struct WorkMenu: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: WorkDetailViewModel
    @Binding var isEdit: Bool
    @Binding var formTitle: FormTitle
    @Binding var openMenu: Bool
    @Binding var hiddingAnimation: Bool
    @Binding var startConfig: DateConfig
    @Binding var endConfig: DateConfig
    
    var tuple: TupleModel
    
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
                            viewModel.workDetails.name != "",
                            viewModel.workDetails.description != "",
                            viewModel.workDetails.cost != ""
                        else { return }
                        
                        let updateArea = [
                            "name": viewModel.workDetails.name.trim(),
                            "description": viewModel.workDetails.description.trim(),
                            "cost": viewModel.workDetails.cost.toDouble(),
                            "startDate": configToDate(startConfig),
                            "endDate": configToDate(endConfig),
                        ]
                        
                        viewModel.workUpdate(
                            workId: tuple.work.id,
                            updateArea: updateArea
                        )
                        
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
            else
            {
                if tuple.work.status == .approved {
                    Button {
                        withAnimation(.snappy) {
                            viewModel.workUpdate(
                                workId: tuple.work.id,
                                updateArea: ["status": ApprovalStatus.finished.rawValue]
                            )
                            
                            dismiss()
                        }
                    } label: {
                        Label("İş Bitti", systemImage: "checkmark.app")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                    .padding(.horizontal, 20)
                    
                    NavigationLink {
                        WorkProductEntry(workId: tuple.work.id)
                            .environmentObject(viewModel)
                    } label: {
                        Label("Malzeme Ekle", systemImage: "plus.viewfinder")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                    .padding(.horizontal, 20)
                }
            }
            
        }
    }
}

