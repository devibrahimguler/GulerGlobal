//
//  GivrecObject.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI

struct GivrecObject: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var formTitle: FormTitle = .none
    
    var addType: ListType
    @Binding var isAdd: Bool
    var companyId: String?
    
    var body: some View {
        Group {
            if addType == .work {
                VStack(spacing: 2) {
                    
                    TextProperty(title: .projeNumber, text: $viewModel.workPNum, formTitle: $formTitle, keyboardType: .numberPad, color: viewModel.isPNum ? .gray : .black)
                        .disabled(viewModel.isPNum)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                if viewModel.isPNum {
                                    viewModel.isPNum = false
                                }
                            }
                        }
                    
                    TextProperty(title: .workName, text: $viewModel.workName, formTitle: $formTitle)
                    
                    TextProperty(title: .workDescription, text: $viewModel.workDesc, formTitle: $formTitle)
                    
                    TextProperty(title: .workPrice, text: $viewModel.workPrice, formTitle: $formTitle, keyboardType: .numberPad)
                    
                    ConfirmationButton {
                        if viewModel.workPNum != "" {
                            if viewModel.workName != "" {
                                if viewModel.workPrice != "" {
                                    if let companyId = companyId {
                                        viewModel.workApprove = "Wait"
                                        
                                        viewModel.createWork(companyId)
                                        
                                       isAdd = false
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 5)
                    
                }
                .padding(10)
                .onAppear {
                    viewModel.workPNum = viewModel.generateProjectNumber() ?? ""
                }
                .onDisappear {
                    formTitle = .none
                    viewModel.workChange(nil)
                }
            } else {
                VStack {
                    let isRec = addType == .rec
                    
                    TextProperty(title: isRec ? .recMoney : .givMoney, text: $viewModel.givrecPrice, formTitle: $formTitle, keyboardType: .numberPad)
                    
                    if formTitle == .recDate || formTitle == .givDate {
                        CustomDatePicker(timePicker: $viewModel.givrecDate, title: isRec ? .recDate : .givDate, formTitle: $formTitle)
                    } else {
                        DateProperty(date: $viewModel.givrecDate, title: isRec ? .recDate : .givDate, formTitle: $formTitle)
                    }
                    
                    
                    ConfirmationButton {
                        if viewModel.givrecPrice != "" {
         
                            
                            isAdd = false
                        }
                    }
                }
            }
        }
        .animation(.snappy, value: formTitle)
        .padding(.horizontal, 5)
        .onDisappear {
            formTitle = .none
        }
    }
}

struct TestGivrecObject: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @State private var isAdd: Bool = false
    
    var body: some View {
        GivrecObject(addType: .work, isAdd: $isAdd)
            .environmentObject(viewModel)
    }
}

#Preview {
    TestGivrecObject()
}
