//
//  DetailView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 14.02.2024.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dataModel: FirebaseDataModel
    
    @State private var isProductList: Bool = false
    @State private var isFinished: Bool = false
    var company: Company
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 0) {
                if company.name != "" {
                    DetailCard(title: .companyName, text: "Firma Adı", desc: company.name)
                        .padding(.horizontal)
                }
                
                if company.address != "" {
                    DetailCard(title: .companyAddress, text: "Addres", desc: company.address)
                        .padding(.horizontal)
                }

                HStack {
                    if company.phone != "" {
                        DetailCard(title: .companyPhone, text: "Telefon", desc: company.phone)
                    }
          
                    if company.work.id != "" {
                        DetailCard(title: .projeNumber, text: "Proje Id", desc: company.work.id)
                    }
                
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                
                HStack {
                    Button {
                        withAnimation(.bouncy()) {
                            isProductList = false
                        }
                    } label: {
                        Text("İş Açıklamarı".uppercased())
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 15, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .background(isProductList ? .gray : .bBlue)
                            .clipShape(RoundedCorner(radius: 10, corners: isProductList ? .allCorners : [.topLeft, .topRight]))
                            .offset(y:isProductList ? 0 : 20)
                    }
                    .disabled(!isProductList)
                    
                    Button {
                        withAnimation(.bouncy()) {
                            isProductList = true
                        }
                    } label: {
                        Text("Malzeme Listesi".uppercased())
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 15, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .background(isProductList ? .bBlue : .gray)
                            .clipShape(RoundedCorner(radius: 10, corners: isProductList ? [.topLeft, .topRight] : .allCorners))
                            .offset(y:isProductList ? 20 : 0)
                    
                    }
                    .disabled(isProductList)
                }
                .padding(.horizontal)
                
                if isProductList {
                    ProductDetail()
                        .padding()
                        .background(.bBlue)
                        .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight, .topLeft]))
                        .padding(.horizontal)
                        .padding(.top)
                } else {
                    WorkDetail()
                        .padding()
                        .background(.bBlue)
                        .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight, .topRight]))
                        .padding(.horizontal)
                        .padding(.top)
                }

            }
            .navigationTitle("Guler Global")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .onAppear {
            UITabBar.changeTabBarState(shouldHide: true)
        }
    }
    
    @ViewBuilder
    func WorkDetail() -> some View {
        VStack(spacing: 0) {
            if company.work.name != "" {
                DetailCard(title: .workName, text: "İş İsmi", desc: company.work.name)
                    .padding(.horizontal)
            }
            
            if company.work.desc != "" {
                DetailCard(title: .workDescription, text: "İş Açıklaması", desc: company.work.desc)
                    .padding(.horizontal)
            }
            
            HStack {
                DetailCard(title: .workPrice, text: "İŞ FİYATI", desc: "\(company.work.price.customDouble()) ₺")
                
                DetailCard(title: .remMoney, text: "İŞ KALAN PARA", desc: "\(company.work.accept.remMoney.customDouble()) ₺", color: .red)
                
                if !(company.work.approve == "Finished") {
                    if company.work.accept.remMoney == 0 {
                        VStack(alignment: .center) {
                            Text("Bitti".uppercased())
                                .foregroundStyle(.black)
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(.hWhite)
                                .clipShape(RoundedCorner(radius: 10))
                                .overlay {
                                    RoundedCorner(radius: 10)
                                        .stroke(style: .init(lineWidth: 1))
                                        .fill(.gray)
                                }
                            
                            Button {
                                withAnimation(.snappy) {
                                    isFinished = true
                                    
                                    dataModel.companyName = company.name
                                    dataModel.companyAddress = company.address
                                    dataModel.companyPhone = company.phone
                    
                                    dataModel.workPNum = company.work.id
                                    dataModel.workName = company.work.name
                                    dataModel.workDesc = company.work.desc
                                    dataModel.workPrice = "\(company.work.price)"
                                    dataModel.workApprove = "Finished"
                                
                                    dataModel.workRem = "\(company.work.accept.remMoney)"
                                    dataModel.isExpiry = company.work.accept.isExpiry
                                    dataModel.recDateList = company.work.accept.recList
                                    dataModel.expDateList = company.work.accept.expList
                                    dataModel.workStartDate = company.work.accept.startDate
                                    dataModel.workFinishDate = company.work.accept.finishDate

                                    dataModel.update()
                                }
                            } label: {
                                Image(systemName: isFinished ? "checkmark.square" : "square")
                            }
                            
                        }
                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                    }
                }
            }
            .padding(.horizontal)
            
            if company.work.accept.recList.count > 0 {
                VStack(spacing: 5) {
                    Text("Alınan Paralar".uppercased())
                        .font(.system(size: 15, weight: .black, design: .rounded))
                        .padding(.horizontal, 25)
                        .padding(.vertical, 5)
                        .foregroundStyle(.white)
                        .background(.green)
                        .clipShape(RoundedCorner(radius: 20))
                        .overlay {
                            RoundedCorner(radius: 20)
                                .stroke(style: .init(lineWidth: 1))
                                .fill(.gray)
                                .shadow(color: colorScheme == .light ? .black: .white ,radius: 10)
                        }
                

                    
                    ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                            ForEach(company.work.accept.recList, id: \.self) { rec in
                                
                                DetailCard(title: .recMoney ,text:"\(rec.date.getStringDate())" , desc: "\(rec.price.customDouble()) ₺", color: .green)
                                    .frame(width: (UIScreen.main.bounds.width / 2) - 20)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    }
                }
                .padding(.top, 5)
                .foregroundStyle(.black)
            }
            
            if company.work.accept.isExpiry {
                if company.work.accept.expList.count > 0 {
                    VStack(spacing: 5) {
                        Text("Alınacak Paralar".uppercased())
                            .font(.system(size: 15, weight: .black, design: .rounded))
                            .padding(.horizontal, 25)
                            .padding(.vertical, 5)
                            .foregroundStyle(.black)
                            .background(.yellow)
                            .clipShape(RoundedCorner(radius: 20))
                            .overlay {
                                RoundedCorner(radius: 20)
                                    .stroke(style: .init(lineWidth: 1))
                                    .fill(.gray)
                                    .shadow(color: colorScheme == .light ? .black: .white ,radius: 10)
                            }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(company.work.accept.expList, id: \.self) { exp in
                                    DetailCard(title: .recMoney ,text:"\(exp.date.getStringDate())" , desc: "\(exp.price.customDouble()) ₺", color: .yellow)
                                        .frame(width: (UIScreen.main.bounds.width / 2) - 20)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 15)
                        }
                    }
                    .padding(.top, 5)
                    .foregroundStyle(.black)
                }
            }
            
            HStack {
                DetailCard(title: .startDate ,text: "Başlama Tarihi", desc: company.work.accept.startDate.formatted(date: .long, time: .omitted))
   
                
                DetailCard(title: .finishDate ,text: "Bitiş Tarihi", desc: company.work.accept.finishDate.formatted(date: .long, time: .omitted))
            }
            .padding([.horizontal, .bottom])
        }
        .background(colorScheme == .dark ? .black : .white)
        .clipShape(RoundedCorner(radius: 5))
        .shadow(color: colorScheme == .dark ? .white : .black ,radius: 5)
    }
    
    @ViewBuilder
    func ProductDetail() -> some View {
        VStack(spacing: 0) {
            ForEach(company.work.product, id: \.self) { pro in
                ProductCard(isDetail: true, pro: pro) {
                    
                    dataModel.companyName = company.name
                    dataModel.companyAddress = company.address
                    dataModel.companyPhone = company.phone
                    
                    dataModel.workPNum = company.work.id
                    dataModel.workName = company.work.name
                    dataModel.workDesc = company.work.desc
                    dataModel.workPrice = "\(company.work.price)"
                    dataModel.workApprove = company.work.approve
                    
                    dataModel.workRem = "\(company.work.accept.remMoney)"
                    dataModel.isExpiry = company.work.accept.isExpiry
                    dataModel.recDateList = company.work.accept.recList
                    dataModel.expDateList = company.work.accept.expList
                    dataModel.workStartDate = company.work.accept.startDate
                    dataModel.workFinishDate = company.work.accept.finishDate
                    
                    dataModel.productList = []
                    for p in company.work.product {
                        if p == pro {
                            let newPro = Product(name: pro.name, quantity: pro.quantity, price: pro.price, suggestion: pro.suggestion, purchased: pro.purchased, isBought: true)
                            dataModel.productList.append(newPro)
                        } else {
                            dataModel.productList.append(p)
                        }
                    }
                    
                    dataModel.update()
                }
            }
        }
        .padding([.vertical], 10)
        .frame(maxWidth: .infinity)
        .background(colorScheme == .dark ? .black : .white)
        .clipShape(RoundedCorner(radius: 5))
        .shadow(color: colorScheme == .dark ? .white : .black ,radius: 5)
    }
}

struct TestDetailView: View {
    @StateObject private var coreDataModel: FirebaseDataModel = .init()
    
    var body: some View {
        if let company = coreDataModel.companies.last {
            DetailView(company: company)
        }
    }
}

#Preview {
    TestDetailView()
        .preferredColorScheme(.dark)
}

