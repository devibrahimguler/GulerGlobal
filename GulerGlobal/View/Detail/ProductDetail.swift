//
//  ProductDetail.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.10.2025.
//

import SwiftUI

struct ProductDetail: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: MainViewModel
    
    @State private var dateConfig: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    
    @State private var isEditProduct: Bool = false
    @State private var formTitle: FormTitle = .none
    
    @State private var hiddingAnimation: Bool = false
    @State private var openMenu: Bool = false
    
    var product: CompanyProduct
    var companyId: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                
                VStack(spacing: 0) {
                    CustomTextField(title: .productName, text: $viewModel.companyProductDetails.name, formTitle: $formTitle)
                        .disabled(!isEditProduct)
                    
                    CustomTextField(title: .productQuantity, text: $viewModel.companyProductDetails.quantity, formTitle: $formTitle)
                        .disabled(!isEditProduct)
                    
                    CustomTextField(title: .productPrice, text: $viewModel.companyProductDetails.price, formTitle: $formTitle)
                        .disabled(!isEditProduct)
                }
                .scaleEffect(x: isEditProduct ? 0.97 : 1, y: isEditProduct ? 0.97 : 1)
                .animation(isEditProduct ? .easeInOut(duration: 0.5).repeatForever() : .easeInOut(duration: 0.5), value: isEditProduct)
                .padding(.top, 25)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                
                VStack(spacing: 5) {
                    CustomDatePicker(dateConfig: $dateConfig, title: .productPurchased, formTitle: $formTitle)
                }
                .foregroundStyle(.isText)
                .disabled(!isEditProduct)
                .scaleEffect(x: isEditProduct ? 0.97 : 1, y: isEditProduct ? 0.97 : 1)
                .animation(isEditProduct ? .easeInOut(duration: 0.5).repeatForever() : .easeInOut(duration: 0.5), value: isEditProduct)
                .padding(.top, 15)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                VStack(spacing: 5) {
                    
                    OldPricesListView(
                        title: "Eski Birim Fiyatları",
                        list: product.oldPrices,
                        companyId: companyId,
                        productId: product.id,
                        hiddingAnimation: $hiddingAnimation
                    )
                    
                }
                .opacity(product.oldPrices.isEmpty || isEditProduct ? 0 : 1)
                .animation(.linear, value: hiddingAnimation)
            }
            .padding(.horizontal, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2))
        .blur(radius: openMenu ? 5 : 0)
        .disabled(openMenu)
        .overlay(alignment: .bottom) {
            
            ProductMenu(
                isEdit: $isEditProduct,
                formTitle: $formTitle,
                openMenu: $openMenu,
                dateConfig: dateConfig,
                product: product,
                companyId: companyId
            )
            .environmentObject(viewModel)
            .offset(y: openMenu ? 0 : 1000)
            
        }
        .animation(.linear, value: openMenu)
        .navigationBarBackButtonHidden(openMenu || isEditProduct)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    hideKeyboard()
                    openMenu.toggle()
                } label: {
                    Image(systemName: openMenu ? "xmark" : "filemenu.and.selection")
                        .contentTransition(.symbolEffect(.replace.magic(fallback: .offUp.wholeSymbol), options: .nonRepeating))
                }
            }
        }
        .onAppear {
            viewModel.updateCompanyProductDetails(with: product)
            dateConfig = viewModel.companyProductDetails.date.dateToConfig()
        }
        .onDisappear {
            viewModel.updateCompanyProductDetails(with: nil)
        }
    }
}

struct Test_ProductDetailView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        ProductDetail(product: example_CompanyProduct, companyId: example_Company.id)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_ProductDetailView()
}
