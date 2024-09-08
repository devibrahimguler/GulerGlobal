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
    @State private var isEditCompany: Bool = false
    @State private var formTitle: FormTitle = .none
    
    var company: Company
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 0) {
                if company.name != "" {
                    TextProperty(title: .companyName, text: $dataModel.companyName, formTitle: $formTitle)
                        .disabled(!isEditCompany)
              
                }
                
                if company.address != "" {
                    TextProperty(title: .companyAddress, text: $dataModel.companyAddress, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                }

                HStack {
                    if company.phone != "" {
                        TextProperty(title: .companyPhone, text: $dataModel.companyPhone, formTitle: $formTitle)
                            .disabled(!isEditCompany)
                    }
          
                    /*
                     if company.work.id != "" {
                         TextProperty(title: .projeNumber, text: $dataModel.workPNum, formTitle: $formTitle)
                             .disabled(!isEditCompany)
                     }
                     */
                
                }
                .padding(.bottom, 5)
                
                
                HStack {
                    Button {
                        withAnimation(.bouncy()) {
                            isProductList = false
                        }
                    } label: {
                        Text("İş Açıklamarı".uppercased())
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 10, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .background(isProductList ? .gray : .bBlue)
                            .clipShape(RoundedCorner(radius: 10, corners: isProductList ? .allCorners : [.topLeft, .topRight]))
                            .offset(y:isProductList ? 0 : 10)
                    }
                    .disabled(!isProductList)
                    
                    Button {
                        withAnimation(.bouncy()) {
                            isProductList = true
                        }
                    } label: {
                        Text("Malzeme Listesi".uppercased())
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 10, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .background(isProductList ? .bBlue : .gray)
                            .clipShape(RoundedCorner(radius: 10, corners: isProductList ? [.topLeft, .topRight] : .allCorners))
                            .offset(y:isProductList ? 10 : 0)
                    
                    }
                    .disabled(isProductList)
                }
                .padding(.horizontal, 5)
                
                if isProductList {
                    /*
                     ProductDetail()
                         .padding()
                         .background(.bBlue)
                         .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight, .topLeft]))
                         .padding(.horizontal, 5)
                         .padding(.top, 10)
                     */
                } else {
                    /*
                     WorkView(isFinished: $isFinished, formTitle: $formTitle, company: company)
                         .padding(5)
                         .background(.bBlue)
                         .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight, .topRight]))
                         .padding(.horizontal, 5)
                         .padding(.top, 10)
                         .environmentObject(dataModel)
                     */
                }

            }
            .navigationTitle("Guler Global")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .onAppear {
            dataModel.companyName = company.name
            dataModel.companyAddress = company.address
            dataModel.companyPhone = company.phone
            
            UITabBar.changeTabBarState(shouldHide: true)
        }
        .toolbar(content: {
            Button {
                withAnimation(.spring) {
                    isEditCompany.toggle()
                }
            } label: {
                Text(isEditCompany ? "KAYDET" : "DÜZENLE")
                    .foregroundStyle(isEditCompany ? .green : .yellow)
            }

        })
    }
    
    /*
     @ViewBuilder
     func ProductDetail() -> some View {
         VStack(spacing: 0) {
             ForEach(work.product, id: \.self) { pro in
                 ProductCard(isDetail: true, pro: pro) {
                     
                     dataModel.companyName = company.name
                     dataModel.companyAddress = company.address
                     dataModel.companyPhone = company.phone
                     
                     dataModel.workPNum = work.id
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
     */
}

struct TestDetailView: View {
    @StateObject private var dataModel: FirebaseDataModel = .init()
    
    var body: some View {
        if let company = dataModel.companies.last {
            DetailView(company: company)
                .environmentObject(dataModel)
        }
    }
}

#Preview {
    TestDetailView()
}

