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
                                .navigationTitle(company.name)
                                .environmentObject(viewModel)
                        } label: {
                            SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                                ProductCard(product: product, isSupplier: isSupplier)
                            }
                            actions: {
                                Action(tint: .red, icon: "trash.fill") {
                                    withAnimation(.snappy) {
                                        if isSupplier {
                                            viewModel.deleteCompanyProduct(
                                                productId: product.id
                                            )
                                        } else {
                                            if let _ = workId,
                                               let companyProduct = viewModel.allProducts.first(where: { $0.companyId == product.companyId }) {
                                                
                                                let quantity = companyProduct.quantity + product.quantity
                                                let updateArea = [
                                                    "quantity": quantity,
                                                ]
                                                
                                                viewModel.updateCompanyProduct(productId: product.id, updateArea: updateArea)
                                                viewModel.deleteWorkProduct(productId: product.id)
                                                
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
    companyId: "1",
    name: "Company Work",
    description: "Company Work",
    cost: 0,
    status: .pending,
    startDate: .now,
    endDate: .now,
    products: example_WorkProductList,
)

var example_WorkList = [
    example_Work,
]

var example_Company = Company(
    id: "0",
    name: "GulerGlobal",
    address: "Burhaniye mahallesi, Ali galip sokak no: 9",
    phone: "(554) 170 16 35",
    status: .current
)

var example_TupleModel = TupleModel(
    company: example_Company,
    work: example_Work
)

var example_Product = Product(
    id: "0001",
    companyId: "47",
    name: "30x20x1.5 Profil",
    quantity: 100,
    price: 300,
    date: .now,
    oldPrices: example_OldPriceList
)

var example_ProductList = [
    example_Product,
    example_Product,
    example_Product,
    example_Product,
    example_Product,
]

var example_WorkProduct = WorkProduct(
    id: "0001",
    workId: "47",
    productId: "47",
    quantity: 100,
    date: .now
)

var example_WorkProductList = [
    example_WorkProduct,
    example_WorkProduct,
    example_WorkProduct,
    example_WorkProduct,
    example_WorkProduct,
]


var example_StatementList = [
    Statement(id: "1", companyId: "1", amount: 1000, date: .now, status: .input),
    Statement(id: "2", companyId: "1", amount: 1000, date: .now, status: .input),
    Statement(id: "3", companyId: "1", amount: 1000, date: .now, status: .input),
    Statement(id: "4", companyId: "1", amount: 1000, date: .now, status: .input),
    Statement(id: "5", companyId: "1", amount: 1000, date: .now, status: .input),
    Statement(id: "6", companyId: "1", amount: 1000, date: .now, status: .output),
    Statement(id: "7", companyId: "1", amount: 1000, date: .now, status: .output),
    Statement(id: "8", companyId: "1", amount: 1000, date: .now, status: .output),
    Statement(id: "9", companyId: "1", amount: 1000, date: .now, status: .output),
    Statement(id: "10", companyId: "1", amount: 1000, date: .now, status: .output)
    
]

var example_OldPriceList = [
    OldPrice(price: 100, date: .now),
    OldPrice(price: 100, date: .now),
    OldPrice(price: 100, date: .now),
    OldPrice(price: 100, date: .now),
    OldPrice(price: 100, date: .now),
    OldPrice(price: 100, date: .now),
]
