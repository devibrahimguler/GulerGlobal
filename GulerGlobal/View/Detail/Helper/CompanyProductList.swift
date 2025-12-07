//
//  CompanyProductList.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.02.2025.
//

import SwiftUI

struct CompanyProductList: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isHidden: Bool = true
    @State private var isReset: Bool = true
    
    var title: String
    var list: [CompanyProduct]
    var company: Company
    var workId: String?
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
                            ProductDetail(product: product, companyId: company.id)
                                .onAppear {
                                    isReset.toggle()
                                }
                                .navigationTitle(company.name)
                                .environmentObject(viewModel)
                        } label: {
                            SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                                CompanyProductCard(companyProduct: product)
                            }
                            actions: {
                                Action(tint: .red, icon: "trash.fill") {
                                    withAnimation(.snappy) {
                                        let productIds = viewModel.workProducts.filter { $0.productId == product.id }.map { $0.id }
                                        if productIds.count > 0 {
                                            viewModel.multipleWorkProductDelete(productIds: productIds)
                                        }
                                        
                                        viewModel.companyProductDelete(
                                            productId: product.id
                                        )
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

struct Test_CompanyProductList: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @State private var hiddingAnimation: Bool = false
    
    var body: some View {
        CompanyProductList(
            title: "Malzeme Listesi",
            list: example_CompanyProductList,
            company: example_Company,
            hiddingAnimation: $hiddingAnimation
        )
        .environmentObject(viewModel)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        
    }
}

#Preview {
    Test_CompanyProductList()
}
