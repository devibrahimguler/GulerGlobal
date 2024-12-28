//
//  DetailView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 14.02.2024.
//

import SwiftUI

struct CompanyDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: MainViewModel
    
    @State private var isEditCompany: Bool = false
    @State private var formTitle: FormTitle = .none
    
    @State private var addType: ListType = .none
    @State private var isAdd: Bool = false
    
    var company: Company
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 10) {
                VStack(spacing: 0) {
                    TextProperty(title: .companyName, text: $viewModel.companyName, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                    
                    TextProperty(title: .companyAddress, text: $viewModel.companyAddress, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                    
                    TextProperty(title: .companyPhone, text: $viewModel.companyPhone, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                }
                .padding(10)
                .background(.background, in: .rect(cornerRadius: 20))
                
                VStack(spacing: 10) {
                    VStack {
                        
                        Button {
                            isAdd = true
                            addType = .work
                        } label: {
                            Text("İŞ EKLE")
                                .customAddBorder(.green)
                        }
                        
                        HStack(alignment: .center) {
                            Button {
                                isAdd = true
                                addType = .rec
                            } label: {
                                VStack(alignment: .center, spacing: 1) {
                                    Text("ALACAK")
                                    Text("EKLE")
                                }
                                .customAddBorder(.yellow)
                            }
                            
                            Button {
                                isAdd = true
                                addType = .give
                            } label: {
                                VStack(alignment: .center, spacing: 1) {
                                    Text("VERECEK")
                                    Text("EKLE")
                                }
                                .customAddBorder()
                            }
                        }
                    }
                    .customAddTwoBorder()
                    
                    Text("GİRDİLER")
                        .foregroundStyle(.black)
                        .customBorder(.hWhite)
                      
                    
                    VStack(spacing: 10) {
                        ForEach(company.works, id: \.self) { workId in
                            let work = viewModel.getWorkById(workId)
                            if company.id == work.companyId {
                                let approved = work.approve == "Approve" ? true : false
                                
                                Card(work: work, isApprove: approved)
                            }
                        }
                    }
                    .customAddTwoBorder()

                }
                .opacity(isEditCompany ? 0 : 1)
            }
            .navigationTitle("Guler Global")
            .navigationBarTitleDisplayMode(.inline)
            .blur(radius: isAdd ? 5 : 0)
        }
        .padding()
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2))
        .onAppear {
            viewModel.companyChange(company)
            UITabBar.changeTabBarState(shouldHide: true)
        }
        .onDisappear {
            viewModel.companyChange(nil)
        }
        .toolbar(content: {
            Button {
                withAnimation(.spring) {
                    
                    if isEditCompany {
                        viewModel.updateCompany(.init(
                            id: company.id,
                            name: viewModel.companyName,
                            address: viewModel.companyAddress,
                            phone: viewModel.companyPhone,
                            works: company.works))
                    }
                    
                    viewModel.tab = .Profile
                    formTitle = .none
                    isEditCompany.toggle()
                }
            } label: {
                Text(isEditCompany ? "KAYDET" : "DÜZENLE")
                    .foregroundStyle(isEditCompany ? .green : .yellow)
                    .font(.system(size: 14, weight: .black, design: .monospaced))
            }
            
        })
        .sheet(isPresented: $isAdd) {
            GivrecObject(addType: addType, isAdd: $isAdd, companyId: company.id)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(.thinMaterial)
                .presentationCornerRadius(10)
                .environmentObject(viewModel)
            
        }
    }
}

struct TestDetailView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    private let company: Company = .init(id: "0", name: "Firma Adı", address: "Address", phone: "(554) 170 16 35", works: ["0001", "0002", "0003", "0004", "0005"])
    
    private let works: [Work] = [
        .init(id: "0001", companyId: "0", name: "iş ismi", desc: "iş açıklama", price: 10000, approve: "Wait", accept: .init(remMoney: 10000, recList: [.init(date: .now, price: 10000)], expList: [], start: .now, finished: .now), products: []),
        
            .init(id: "0002", companyId: "0", name: "iş ismi 2", desc: "iş açıklama 2", price: 20000, approve: "Approve", accept: .init(remMoney: 10000, recList: [.init(date: .now, price: 10000)], expList: [], start: .now, finished: .now), products: []),
        
            .init(id: "0003", companyId: "0", name: "iş ismi 3", desc: "iş açıklama 3", price: 30000, approve: "Wait", accept: .init(remMoney: 10000, recList: [.init(date: .now, price: 10000)], expList: [], start: .now, finished: .now), products: []),
        
            .init(id: "0004", companyId: "0", name: "iş ismi 4", desc: "iş açıklama 4", price: 40000, approve: "Approve", accept: .init(remMoney: 10000, recList: [.init(date: .now, price: 10000)], expList: [], start: .now, finished: .now), products: []),
        
            .init(id: "0005", companyId: "0", name: "iş ismi 5", desc: "iş açıklama 5", price: 50000, approve: "Wait", accept: .init(remMoney: 10000, recList: [.init(date: .now, price: 10000)], expList: [], start: .now, finished: .now), products: [])
    ]
    
    var body: some View {
        CompanyDetailView(company: company)
            .environmentObject(viewModel)
            .onAppear {
                viewModel.companies = [company]
                viewModel.works = works
            }
    }
}

#Preview {
    TestDetailView()
}

extension View {
    func customBorder(_ color: Color = .red) -> some View {
        return self
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(style: .init(lineWidth: 3))
            }
            .font(.system(size: 15, weight: .black, design: .monospaced))
            .foregroundStyle(.white)
            .padding(10)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(style: .init(lineWidth: 3))
            }
            .padding(10)
            .background(.background, in: .rect(cornerRadius: 20))
        
    }
    
    func customAddBorder(_ color: Color = .red) -> some View {
        return self
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(style: .init(lineWidth: 3))
            }
            .font(.system(size: 15, weight: .black, design: .monospaced))
            .foregroundStyle(.white)
        
    }
    
    func customAddTwoBorder(_ color: Color = .red) -> some View {
        return self
            .padding(10)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(style: .init(lineWidth: 3))
            }
            .padding(10)
            .background(.background, in: .rect(cornerRadius: 20))
        
    }
}
