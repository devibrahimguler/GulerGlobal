//
//  WorkDetailView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 22.09.2024.
//

import SwiftUI

struct WorkDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: MainViewModel
    
    @State private var isEditWork: Bool = false
    @State private var formTitle: FormTitle = .none
    
    @State private var addType: ListType = .none
    @State private var isAdd: Bool = false
    
    var work: Work
    var isBidView: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                TextProperty(title: .workName, text: $viewModel.workName, formTitle: $formTitle)
                    .disabled(!isEditWork)
                    .scaleEffect(x: isEditWork ? 0.97 : 1, y: isEditWork ? 0.97 : 1)
                    .animation(.easeInOut(duration: 0.5).repeatForever(), value: isEditWork)
                
                
                TextProperty(title: .workDescription, text: $viewModel.workDesc, formTitle: $formTitle)
                    .disabled(!isEditWork)
                    .scaleEffect(x: isEditWork ? 0.97 : 1, y: isEditWork ? 0.97 : 1)
                    .animation(.easeInOut(duration: 0.5).repeatForever(), value: isEditWork)
                
                HStack {
                    TextProperty(title: .workPrice, text: $viewModel.workPrice, formTitle: $formTitle)
                        .disabled(!isEditWork)
                        .scaleEffect(x: isEditWork ? 0.97 : 1, y: isEditWork ? 0.97 : 1)
                        .animation(.easeInOut(duration: 0.5).repeatForever(), value: isEditWork)
                    
                    if !(work.approve == "Finished") {
                        
                        
                        if work.accept.remMoney == 0 {
                            if !isEditWork {
                                VStack {
                                    Text("BİTTİ")
                                        .foregroundStyle(.red)
                                        .padding(5)
                                        .background(.white)
                                        .foregroundStyle(.gray)
                                        .clipShape( RoundedCorner(radius: 10))
                                        .overlay {
                                            RoundedCorner(radius: 10)
                                                .stroke(style: .init(lineWidth: 3))
                                                .fill(.red)
                                        }
                                        .zIndex(1)
                                        .padding(.horizontal, 5)
                                    
                                    Button {
                                        withAnimation(.snappy) {
                                            viewModel.workUpdate(
                                                .init(id: work.id,
                                                      companyId: work.companyId,
                                                      name: work.name,
                                                      desc: work.desc,
                                                      price: work.price,
                                                      approve: "Finished",
                                                      accept: work.accept,
                                                      products: work.products)
                                            )
                                            
                                        }
                                    } label: {
                                        Image(systemName: "square")
                                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                                            .foregroundStyle(.red)
                                    }
                                }
                                .padding(.horizontal, 5)
                                .font(.system(size: 15, weight: .black, design: .monospaced))
                            }
                        } else {
                            TextProperty(title: .remMoney, text: $viewModel.acceptRem, formTitle: $formTitle, color: .red)
                                .disabled(true)
                        }
                    }
                    
                }
                
                Divider()
                    .padding(.vertical, 10)
                
                Group {
                    if formTitle == .startDate {
                        CustomDatePicker(timePicker:  $viewModel.acceptStart, title: .startDate, formTitle: $formTitle)
                    } else {
                        DateProperty(date: $viewModel.acceptStart, title: .startDate, formTitle: $formTitle)
                    }
                    
                    if formTitle == .finishDate {
                        CustomDatePicker(timePicker:  $viewModel.acceptFinished, title: .finishDate, formTitle: $formTitle)
                    } else {
                        DateProperty(date: $viewModel.acceptFinished, title: .finishDate, formTitle: $formTitle)
                    }
                }
                .disabled(!isEditWork)
                .scaleEffect(x: isEditWork ? 0.97 : 1, y: isEditWork ? 0.97 : 1)
                .animation(.easeInOut(duration: 0.5).repeatForever(), value: isEditWork)
                
                
                if !isBidView {
                    VStack(spacing: 0) {
                        Divider()
                            .padding(.vertical, 10)
                        
                        CustomList(
                            title: "ALINAN PARA EKLE",
                            color: .green,
                            type: .recStatement,
                            isAdd: $isAdd,
                            addType: $addType,
                            list: work.accept.recList,
                            work: work)
                        .environmentObject(viewModel)
                        
                        Divider()
                            .padding(.vertical, 10)
                        
                        CustomList(
                            title: "ALINACAK PARA EKLE",
                            color: .yellow,
                            type: .expStatement,
                            isAdd: $isAdd,
                            addType: $addType,
                            list: work.accept.expList,
                            work: work)
                        .environmentObject(viewModel)
                        
                        Divider()
                            .padding(.vertical, 10)
                        
                        CustomList(
                            title: "MALZEME EKLE",
                            color: .red,
                            type: .product,
                            isAdd: $isAdd,
                            addType: $addType,
                            list: work.products,
                            work: work)
                        .environmentObject(viewModel)
                    }
                    .opacity(isEditWork ? 0 : 1)
                    .frame(maxHeight: isEditWork ? 0 : .infinity)
                }
                
            }
            .navigationTitle("Guler Global")
            .navigationBarTitleDisplayMode(.inline)
            .blur(radius: isAdd ? 5 : 0)
            .padding(.horizontal, 5)
        }
        .onAppear {
            viewModel.workChange(work)
            UITabBar.changeTabBarState(shouldHide: true)
        }
        .onDisappear {
            viewModel.workChange(nil)
        }
        .toolbar(content: {
            Button {
                withAnimation(.spring) {
                    if isEditWork {
                        let remMoney = (viewModel.workPrice.toDouble() - work.price) + work.accept.remMoney
                        viewModel.acceptRem = "\(remMoney)"
                        
                        viewModel.workUpdate(.init(
                            id: work.id,
                            companyId: work.companyId,
                            name: viewModel.workName,
                            desc: viewModel.workDesc,
                            price: viewModel.workPrice.toDouble(),
                            approve: work.approve,
                            accept: .init(
                                remMoney: remMoney,
                                recList: work.accept.recList,
                                expList: work.accept.expList,
                                start: viewModel.acceptStart,
                                finished: viewModel.acceptFinished),
                            products: work.products))
                        
                        viewModel.workChange(nil)
                    } else {
                        viewModel.workChange(work)
                    }
                    
                    formTitle = .none
                    
                    isEditWork.toggle()
                }
            } label: {
                Text(isEditWork ? "KAYDET" : "DÜZENLE")
                    .foregroundStyle(isEditWork ? .green : .yellow)
                    .font(.system(size: 14, weight: .black, design: .monospaced))
            }
            
        })
        .onChange(of: isAdd, { oldValue, newValue in
            addType = addType
        })
        .onReceive(viewModel.$workPrice) { price in
            viewModel.remMoneySnapping(price: price.toDouble(), work: work)
        }
        .sheet(isPresented: $isAdd) {
            InsertObject(addType: addType, isAdd: $isAdd, work: work)
                .presentationDetents(addType == .product ? [.large] : [.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(.thinMaterial)
                .presentationCornerRadius(10)
                .environmentObject(viewModel)
                
        }
    }
}

struct TestWorkDetailView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    private let work: Work = .init(
        id: "0001",
        companyId: "0",
        name: "iş ismi",
        desc: "iş açıklama",
        price: 10000,
        approve: "Wait",
        accept: .init(
            remMoney: 5000,
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
        WorkDetailView(work: work)
            .environmentObject(viewModel)
    }
}

#Preview {
    TestWorkDetailView()
}
