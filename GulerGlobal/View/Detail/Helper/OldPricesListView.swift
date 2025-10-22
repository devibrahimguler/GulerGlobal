//
//  OldPricesListView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.10.2025.
//

import SwiftUI

struct OldPricesListView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isHidden: Bool = true
    @State private var isReset: Bool = true
    
    var title: String
    var list: [OldPrice]
    var companyId: String
    var productId: String
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
                    ForEach(list, id: \.self) { oldPrice in
                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                            OldPricesCard(oldPrice: oldPrice)
                        }
                        actions: {
                             Action(tint: .red, icon: "trash.fill") {
                                 withAnimation(.snappy) {
                                     viewModel.deleteOldPrice(
                                        companyId: companyId,
                                        productId: productId,
                                        oldPriceAId: oldPrice.id
                                     )
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

struct Test_OldPriceListView: View {
    @State private var hiddingAnimation: Bool = false
    var body: some View {
        OldPricesListView(
            title: "Eski Birim Fiyatları",
            list: example_OldPriceList,
            companyId: example_Company.id,
            productId: example_Product.id,
            hiddingAnimation: $hiddingAnimation
        )
    }
}

#Preview {
    Test_OldPriceListView()
}
