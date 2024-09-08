//
//  TakenProductView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11.08.2024.
//

import SwiftUI

struct TakenProductView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dataModel: FirebaseDataModel
    
    var body: some View {
        VStack {
            Divider()
            
            Text("ALINACAK LİSTESİ")
                .font(.system(size: 20, weight: .black, design: .default))
            
            /*
             ScrollView {
                 ForEach(dataModel.takenProducts, id: \.self) { company in
                     VStack {
                         VStack {
                             HStack {
                                 Text("Proje Numarası:")
                                     .foregroundStyle(.blue)
                                 
                                 Text("\(company.work.id)")
                                     .foregroundStyle(.black)
                             }
                         }
                         .font(.system(size: 12, weight: .black, design: .default))
                         .padding(5)
                         .background(.hWhite)
                         .clipShape(RoundedCorner(radius: 5))
                         .overlay {
                             RoundedCorner(radius: 5)
                                 .stroke(style: .init(lineWidth: 1))
                                 .fill(.lGray)
                         }
                         .shadow(color: colorScheme == .dark ? .white : .black ,radius: 5)
                         
                         ForEach(company.work.product, id: \.self) { pro in
                             if !pro.isBought {
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
                     }
                     .background(.bBlue)
                     .clipShape(RoundedCorner(radius: 15))
                     .overlay {
                         RoundedCorner(radius: 15)
                             .stroke(style: .init(lineWidth: 1))
                             .fill(.lGray)
                     }
                     .shadow(color: colorScheme == .dark ? .white : .black ,radius: 5)
                     .padding(.top)
                     
                 }
                 .padding()
             }
             */
        }
    }
}

struct TestTakenProductView: View {
    @StateObject private var dataModel: FirebaseDataModel = .init()
    
    var body: some View {
        TakenProductView()
            .environmentObject(dataModel)
    }
}

#Preview {
    TestTakenProductView()
}
