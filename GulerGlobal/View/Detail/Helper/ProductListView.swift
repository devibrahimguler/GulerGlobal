//
//  ProductListView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.02.2025.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isHidden: Bool = true
    @State private var isReset: Bool = true
    
    var title: String
    var list: [Product]
    var tuple: TupleModel
    @Binding var hiddingAnimation: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 20) {
                NavigationLink {
                    ProductEntryView(tuple: tuple)
                        .environmentObject(viewModel)
                } label: {
                    Image(systemName: "plus.viewfinder")
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.init(degrees: isHidden ? 180 : 0))
                    .onTapGesture {
                        isHidden.toggle()
                        hiddingAnimation.toggle()
                    }
            }
            .padding()
            .background(.background, in: .rect(cornerRadius: 20))
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(list, id: \.self) { product in
                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                            ProductCard(product: product)
                        }
                        actions: {
                            Action(tint: .red, icon: "trash.fill") {
                                viewModel.deleteProduct(
                                    companyId: tuple.company.id,
                                    workId: tuple.work.id,
                                    productId: product.id
                                )
                            }
                            
                            Action(tint: .myGreen, icon: "checkmark.square", isEnabled: !product.isBought) {
                                withAnimation(.snappy) {
                                    viewModel.updateProduct(
                                        companyId: tuple.company.id,
                                        workId: tuple.work.id,
                                        productId: product.id,
                                        updateArea: ["isBought": true]
                                    )
                                }
                            }
                        }
                        .padding(5)
                    }
                }
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(height: isHidden ? 0 : 400)
        }
        .animation(.linear, value: isHidden)
    }
}

struct Test_ProductListView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @State private var hiddingAnimation: Bool = false
    
    var body: some View {
        ProductListView(
            title: "Malzeme Listesi",
            list: example_ProductList,
            tuple: example_TupleModel,
            hiddingAnimation: $hiddingAnimation
        )
        .environmentObject(viewModel)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        
    }
}

#Preview {
    Test_ProductListView()
}

var example_TupleModel = TupleModel(
    company: Company(
        id: "0",
        companyName: "GulerGlobal",
        companyAddress: "Burhaniye mahallesi, Ali galip sokak no: 9",
        contactNumber: "(554) 170 16 35",
        workList: [
            Work(
                id: "0000",
                workName: "Sıcak Press",
                workDescription: "Sıcak press yapılacak",
                totalCost: 20000,
                approve: .approved,
                remainingBalance: 1000,
                statements: [
                    Statement(amount: 1000, date: .now, status: .received),
                    Statement(amount: 1000, date: .now, status: .received),
                    Statement(amount: 1000, date: .now, status: .received),
                    Statement(amount: 1000, date: .now, status: .received),
                    Statement(amount: 1000, date: .now, status: .received),
                    Statement(amount: 1000, date: .now, status: .expired),
                    Statement(amount: 1000, date: .now, status: .expired),
                    Statement(amount: 1000, date: .now, status: .expired),
                    Statement(amount: 1000, date: .now, status: .expired),
                    Statement(amount: 1000, date: .now, status: .expired),
                ],
                startDate: .now,
                endDate: .now,
                productList: [
                    Product(
                        productName: "30x20x1.5 Profil",
                        quantity: 10,
                        unitPrice: 300,
                        suggestion: "Arıkan Metal",
                        purchased: .now),
                    Product(
                        productName: "30x20x1.5 Profil",
                        quantity: 10,
                        unitPrice: 300,
                        suggestion: "Arıkan Metal",
                        purchased: .now),
                    Product(
                        productName: "30x20x1.5 Profil",
                        quantity: 10,
                        unitPrice: 300,
                        suggestion: "Arıkan Metal",
                        purchased: .now),
                    Product(
                        productName: "30x20x1.5 Profil",
                        quantity: 10,
                        unitPrice: 300,
                        suggestion: "Arıkan Metal",
                        purchased: .now),
                    Product(
                        productName: "30x20x1.5 Profil",
                        quantity: 10,
                        unitPrice: 300,
                        suggestion: "Arıkan Metal",
                        purchased: .now),
                ])
        ]),
    work: Work(
        id: "0000",
        workName: "Sıcak Press",
        workDescription: "Sıcak press yapılacak",
        totalCost: 20000,
        approve: .approved,
        remainingBalance: 1000,
        statements: [
            Statement(amount: 1000, date: .now, status: .received),
            Statement(amount: 1000, date: .now, status: .received),
            Statement(amount: 1000, date: .now, status: .received),
            Statement(amount: 1000, date: .now, status: .received),
            Statement(amount: 1000, date: .now, status: .received),
            Statement(amount: 1000, date: .now, status: .expired),
            Statement(amount: 1000, date: .now, status: .expired),
            Statement(amount: 1000, date: .now, status: .expired),
            Statement(amount: 1000, date: .now, status: .expired),
            Statement(amount: 1000, date: .now, status: .expired),
        ],
        startDate: .now,
        endDate: .now,
        productList: [
            Product(
                productName: "30x20x1.5 Profil",
                quantity: 10,
                unitPrice: 300,
                suggestion: "Arıkan Metal",
                purchased: .now),
            Product(
                productName: "30x20x1.5 Profil",
                quantity: 10,
                unitPrice: 300,
                suggestion: "Arıkan Metal",
                purchased: .now),
            Product(
                productName: "30x20x1.5 Profil",
                quantity: 10,
                unitPrice: 300,
                suggestion: "Arıkan Metal",
                purchased: .now),
            Product(
                productName: "30x20x1.5 Profil",
                quantity: 10,
                unitPrice: 300,
                suggestion: "Arıkan Metal",
                purchased: .now),
            Product(
                productName: "30x20x1.5 Profil",
                quantity: 10,
                unitPrice: 300,
                suggestion: "Arıkan Metal",
                purchased: .now),
        ])
)
var example_ProductList = [
    Product(
        productName: "30x20x1.5 Profil",
        quantity: 10,
        unitPrice: 300,
        suggestion: "Arıkan Metal",
        purchased: .now),
    Product(
        productName: "30x20x1.5 Profil",
        quantity: 10,
        unitPrice: 300,
        suggestion: "Arıkan Metal",
        purchased: .now),
    Product(
        productName: "30x20x1.5 Profil",
        quantity: 10,
        unitPrice: 300,
        suggestion: "Arıkan Metal",
        purchased: .now),
    Product(
        productName: "30x20x1.5 Profil",
        quantity: 10,
        unitPrice: 300,
        suggestion: "Arıkan Metal",
        purchased: .now),
    Product(
        productName: "30x20x1.5 Profil",
        quantity: 10,
        unitPrice: 300,
        suggestion: "Arıkan Metal",
        purchased: .now),
]
var example_StatementList = [
    Statement(amount: 1000, date: .now, status: .received),
    Statement(amount: 1000, date: .now, status: .received),
    Statement(amount: 1000, date: .now, status: .received),
    Statement(amount: 1000, date: .now, status: .received),
    Statement(amount: 1000, date: .now, status: .received),
    Statement(amount: 1000, date: .now, status: .expired),
    Statement(amount: 1000, date: .now, status: .expired),
    Statement(amount: 1000, date: .now, status: .expired),
    Statement(amount: 1000, date: .now, status: .expired),
    Statement(amount: 1000, date: .now, status: .expired),
]
