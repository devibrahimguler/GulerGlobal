//
//  WorkMenu.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 28.10.2025.
//

import SwiftUI

struct WorkMenu: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var workVM: WorkViewModel
    @Binding var isEdit: Bool
    @Binding var formTitle: FormTitle
    @Binding var openMenu: Bool
    @Binding var startConfig: DateConfig
    @Binding var endConfig: DateConfig
    
    var tuple: TupleModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Button {
                withAnimation(.spring) {
                    workVM.updateWorkDetails(with: tuple.work)
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
                            "workName": workVM.workDetails.name.trim(),
                            "workDescription": workVM.workDetails.description.trim(),
                            "remainingBalance": workVM.workDetails.remainingBalance.toDouble(),
                            "totalCost": workVM.workDetails.totalCost.toDouble(),
                            "startDate": configToDate(startConfig),
                            "endDate": configToDate(endConfig),
                        ]
                        workVM.workUpdate(
                            companyId: tuple.company.id,
                            workId: tuple.work.id,
                            updateArea: updateArea
                        )
                        
                        workVM.updateWorkDetails(with: nil)
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
            else
            {
                if tuple.work.approve == .approved {
                    Button {
                        withAnimation(.snappy) {
                            workVM.workUpdate(
                                companyId: tuple.company.id,
                                workId: tuple.work.id,
                                updateArea: ["approve": ApprovalStatus.finished.rawValue]
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
                        ProductEntry(
                            dataService: workVM.dataService,
                            fetch: workVM.fetch,
                            isLoading: workVM.isLoading,
                            allProducts: workVM.allProducts,
                            companyId: tuple.company.id,
                            workId: tuple.work.id,
                            isSupplier: false,
                            companyList: workVM.companyList
                        )
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

