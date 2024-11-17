//
//  InsertObject.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 16.10.2024.
//

import SwiftUI

struct InsertObject: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var formTitle: FormTitle = .none
    
    var addType: ListType
    @Binding var isAdd: Bool
    var work: Work
    
    var body: some View {
        Group {
            if addType == .product {
                VStack {
                    
                    TextProperty(title: .productName, text: $viewModel.proName, formTitle: $formTitle)
                    
                    TextProperty(title: .productQuantity, text: $viewModel.proQuantity, formTitle: $formTitle, keyboardType: .numberPad)
                    
                    TextProperty(title: .productPrice, text: $viewModel.proPrice, formTitle: $formTitle, keyboardType: .numberPad)
                    
                    TextProperty(title: .productSuggestion, text: $viewModel.proSuggestion, formTitle: $formTitle)
                    
                    if formTitle == .productPurchased {
                        CustomDatePicker(timePicker: $viewModel.proPurchasedDate, title: .productPurchased, formTitle: $formTitle)
                    } else {
                        DateProperty(date: $viewModel.proPurchasedDate, title: .productPurchased, formTitle: $formTitle)
                    }
                    
                    ConfirmationButton {
                        if viewModel.proName != "" {
                            if viewModel.proQuantity != "" {
                                if viewModel.proPrice != "" {
                                    if viewModel.proSuggestion != "" {
                                        viewModel.productList = work.products
                                        
                                        viewModel.productList.append(.init(
                                            name: viewModel.proName,
                                            quantity: viewModel.proQuantity.toInt(),
                                            price: viewModel.proPrice.toDouble(),
                                            suggestion: viewModel.proSuggestion,
                                            purchased: viewModel.proPurchasedDate,
                                            isBought: false))
                                        
                                        viewModel.workUpdate(.init(id: work.id, companyId: work.companyId, name: work.name, desc: work.desc, price: work.price, approve: work.approve, accept: work.accept, products: viewModel.productList))
                                        
                                        viewModel.proName = ""
                                        viewModel.proQuantity = ""
                                        viewModel.proPrice = ""
                                        viewModel.proSuggestion = ""
                                        viewModel.proPurchasedDate = .now
                                        
                                        isAdd = false
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                VStack {
                    let isRec = addType == .recStatement
                    
                    TextProperty(title: isRec ? .recMoney : .expMoney, text: isRec ? $viewModel.workRec : $viewModel.workExp, formTitle: $formTitle, keyboardType: .numberPad)
                    
                    if formTitle == .recDate || formTitle == .expDate {
                        CustomDatePicker(timePicker: isRec ? $viewModel.workRecDate : $viewModel.workExpDate, title: isRec ? .recDate : .expDate, formTitle: $formTitle)
                    } else {
                        DateProperty(date: isRec ? $viewModel.workRecDate : $viewModel.workExpDate, title: isRec ? .recDate : .expDate, formTitle: $formTitle)
                    }
                    
                    
                    ConfirmationButton {
                        if viewModel.workRec != "" || viewModel.workExp != "" {
                            var remMoney = work.price
                            
                            viewModel.recList = work.accept.recList
                            viewModel.expList = work.accept.expList
                            
                            if isRec {
                                viewModel.recList.append(.init(
                                    date: viewModel.workRecDate,
                                    price: viewModel.workRec.toDouble()))
                            } else {
                                viewModel.expList.append(.init(
                                    date: viewModel.workExpDate,
                                    price: viewModel.workExp.toDouble()))
                            }
                            
                            for rec in viewModel.recList {
                                remMoney -= rec.price
                            }
                            
                            viewModel.workUpdate(.init(
                                id: work.id,
                                companyId: work.companyId,
                                name: work.name,
                                desc: work.desc,
                                price: work.price,
                                approve: work.approve,
                                accept: .init(
                                    remMoney: isRec ? remMoney : work.accept.remMoney,
                                    recList: viewModel.recList,
                                    expList: viewModel.expList,
                                    start: work.accept.start,
                                    finished: work.accept.finished),
                                products: work.products))
                            
                            viewModel.workRec = ""
                            viewModel.workExp = ""
                            
                            viewModel.workRecDate = .now
                            viewModel.workExpDate = .now
                            
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

struct TestInsertObject: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @State private var isAdd: Bool = false
    
    private let work: Work = .init(
        id: "0001",
        companyId: "0",
        name: "iş ismi",
        desc: "iş açıklama",
        price: 10000,
        approve: "Wait",
        accept: .init(
            remMoney: 0,
            recList: [
                .init(date: .now, price: 1000),
                .init(date: .now, price: 1000),
                .init(date: .now, price: 1000),
                .init(date: .now, price: 1000),
                .init(date: .now, price: 1000)
            ],
            expList: [
                
                .init(date: .now, price: 1000),
                .init(date: .now, price: 1000),
                .init(date: .now, price: 1000),
                .init(date: .now, price: 1000),
                .init(date: .now, price: 1000),
                
            ],
            start: .now,
            finished: .now),
        products: [
            
            .init(name: "Profil", quantity: 30, price: 300, suggestion: "GulerMetSan", purchased: .now, isBought: false),
            .init(name: "Profil 2", quantity: 30, price: 300, suggestion: "GulerMetSan", purchased: .now, isBought: true),
            .init(name: "Profil 3", quantity: 30, price: 300, suggestion: "GulerMetSan", purchased: .now, isBought: false),
            .init(name: "Profil 4", quantity: 30, price: 300, suggestion: "GulerMetSan", purchased: .now, isBought: true),
            .init(name: "Profil 5", quantity: 30, price: 300, suggestion: "GulerMetSan", purchased: .now, isBought: true),
            .init(name: "Profil 6", quantity: 30, price: 300, suggestion: "GulerMetSan", purchased: .now, isBought: true)
            
        ])
    
    var body: some View {
        InsertObject(addType: .product, isAdd: $isAdd, work: work)
            .environmentObject(viewModel)
    }
}

#Preview {
    TestInsertObject()
}
