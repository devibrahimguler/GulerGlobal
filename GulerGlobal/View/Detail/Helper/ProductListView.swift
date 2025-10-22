//
//  ProductListView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.02.2025.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isHidden: Bool = true
    @State private var isReset: Bool = true
    
    var title: String
    var list: [Product]
    var company: Company
    var workId: String?
    var isSupplier: Bool
    @Binding var hiddingAnimation: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 20) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.init(degrees: isHidden ? 180 : 0))
                    .onTapGesture {
                        isHidden.toggle()
                        hiddingAnimation.toggle()
                    }
                    .padding()
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .circular))
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(list, id: \.self) { product in
                        NavigationLink {
                            ProductDetailView(product: product, companyId: company.id, isSupplier: isSupplier)
                                .onAppear {
                                    isReset.toggle()
                                }
                                .navigationTitle(company.companyName)
                                .environmentObject(viewModel)
                        } label: {
                            SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                                ProductCard(product: product, isSupplier: isSupplier)
                            }
                            actions: {
                                Action(tint: .red, icon: "trash.fill") {
                                    withAnimation(.snappy) {
                                        if isSupplier {
                                            viewModel.deleteProduct(
                                                companyId: company.id,
                                                productId: product.id
                                            )
                                        } else {
                                            if let workId = workId,
                                               let companyProduct = viewModel.allProducts.first(where: { $0.supplierId == product.supplierId }) {
                                                
                                                let quantity = companyProduct.quantity + product.quantity
                                                let updateArea = [
                                                    "quantity": quantity,
                                                ]
                                                
                                                viewModel.updateProductForCompany(companyId: product.supplierId, productId: product.id, updateArea: updateArea)
                                                viewModel.deleteProductForWork(companyId: company.id, workId: workId, productId: product.id)
                                                
                                                dismiss()
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            .padding(5)
                        }
                    }
                }
                .padding(10)
            }
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
            .clipShape(.rect(cornerRadius: 30, style: .continuous))
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
            company: example_Company,
            isSupplier: false,
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

var example_Work = Work(
    id: "0000",
    workName: "Company Work",
    workDescription: "Company Work",
    remainingBalance: 0,
    totalCost: 0,
    approve: .none,
    productList: example_ProductList,
    startDate: .now,
    endDate: .now
)

var example_WorkList = [
    example_Work,
]

var example_Company = Company(
    id: "0",
    companyName: "GulerGlobal",
    companyAddress: "Burhaniye mahallesi, Ali galip sokak no: 9",
    contactNumber: "(554) 170 16 35",
    partnerRole: .current,
    workList: example_WorkList,
    statements: example_StatementList,
    productList: example_ProductList
)

var example_TupleModel = TupleModel(
    company: example_Company,
    work: example_Work
)

var example_Product = Product(
    id: "0001",
    supplierId: "47",
    supplier: "Arıkan Metal",
    productName: "30x20x1.5 Profil",
    quantity: 100,
    unitPrice: 300,
    oldPrices: example_OldPriceList,
    purchased: .now)

var example_ProductList = [
    example_Product,
    example_Product,
    example_Product,
    example_Product,
    example_Product,
]
var example_StatementList = [
    Statement(amount: 1000, date: .now, status: .input),
    Statement(amount: 1000, date: .now, status: .input),
    Statement(amount: 1000, date: .now, status: .input),
    Statement(amount: 1000, date: .now, status: .input),
    Statement(amount: 1000, date: .now, status: .input),
    Statement(amount: 1000, date: .now, status: .output),
    Statement(amount: 1000, date: .now, status: .output),
    Statement(amount: 1000, date: .now, status: .output),
    Statement(amount: 1000, date: .now, status: .output),
    Statement(amount: 1000, date: .now, status: .output),
]

var example_OldPriceList = [
    OldPrice(price: 100, date: .now),
    OldPrice(price: 100, date: .now),
    OldPrice(price: 100, date: .now),
    OldPrice(price: 100, date: .now),
    OldPrice(price: 100, date: .now),
    OldPrice(price: 100, date: .now),
]
