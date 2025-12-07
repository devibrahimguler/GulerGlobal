//
//  WorkProductList.swift
//  GulerGlobal
//
//  Created by ibrahim on 5.12.2025.
//

import SwiftUI

struct WorkProductList: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isHidden: Bool = true
    @State private var isReset: Bool = true
    
    var title: String
    var list: [WorkProduct]
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
                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                            WorkProductCard(workProduct: product)
                        }
                        actions: {
                            Action(tint: .red, icon: "trash.fill") {
                                withAnimation(.snappy) {
                                    if let companyProduct = viewModel.companyProducts.first(where: { $0.id == product.productId }) {
                                        
                                        let quantity = companyProduct.quantity + product.quantity
                                        let updateArea = [
                                            "quantity": quantity,
                                        ]
                                        
                                        viewModel.companyProductUpdate(productId: product.productId, updateArea: updateArea)
                                        viewModel.workProductDelete(productId: product.id)
                                        
                                        dismiss()
                                    }
                                    
                                }
                            }
                        }
                        .padding(5)
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

struct Test_WorkProductList: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @State private var hiddingAnimation: Bool = false
    
    var body: some View {
        WorkProductList(
            title: "Malzeme Listesi",
            list: example_WorkProductList,
            isSupplier: false,
            hiddingAnimation: $hiddingAnimation
        )
        .environmentObject(viewModel)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        
    }
}

#Preview {
    Test_WorkProductList()
}
