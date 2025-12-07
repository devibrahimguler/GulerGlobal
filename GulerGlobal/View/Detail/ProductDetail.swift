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
                
                VStack(spacing: 5) {
                    CustomTextField(title: .productName, text: $viewModel.companyProductDetails.name, formTitle: $formTitle)
                        .disabled(!isEditProduct)
                    
                    CustomTextField(title: .productQuantity, text: $viewModel.companyProductDetails.quantity, formTitle: $formTitle)
                        .disabled(!isEditProduct)
                    
                    CustomTextField(title: .productPrice, text: $viewModel.companyProductDetails.price, formTitle: $formTitle)
                        .disabled(!isEditProduct)
                }
                .scaleEffect(x: isEditProduct ? 0.97 : 1, y: isEditProduct ? 0.97 : 1)
                .animation(isEditProduct ? .easeInOut(duration: 0.5).repeatForever() : .easeInOut(duration: 0.5), value: isEditProduct)
                .padding(10)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                
                VStack(spacing: 5) {
                    CustomDatePicker(dateConfig: $dateConfig, title: .productPurchased, formTitle: $formTitle)
                }
                .foregroundStyle(.isText)
                .disabled(!isEditProduct)
                .scaleEffect(x: isEditProduct ? 0.97 : 1, y: isEditProduct ? 0.97 : 1)
                .animation(isEditProduct ? .easeInOut(duration: 0.5).repeatForever() : .easeInOut(duration: 0.5), value: isEditProduct)
                .padding(10)
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
            .padding(.horizontal, 10)
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
            .offset(y: openMenu ? 0 : 500)
            
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
            dateConfig = dateToConfig(viewModel.companyProductDetails.date)
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

/*
 struct ProductMenu: View {
     @Environment(\.dismiss) private var dismiss
     @EnvironmentObject var viewModel: MainViewModel
     @Binding var isEdit: Bool
     @Binding var formTitle: FormTitle
     @Binding var openMenu: Bool
     
     var dateConfig: DateConfig
     var product: Product
     var companyId: String
     var workId: String?
     var isSupplier: Bool
     
     var body: some View {
         VStack(alignment: .center, spacing: 5) {
             Button {
                 withAnimation(.spring) {
                     viewModel.updateProductDetails(with: product)
                     formTitle = .none
                     openMenu = false
                     isEdit.toggle()
                 }
             } label: {
                 if isEdit {
                     Label("İptal", systemImage: "pencil.slash")
                 } else {
                     Label("Düzenle", systemImage: "square.and.pencil")
                 }
             }
             .frame(maxWidth: .infinity)
             .padding(.vertical, 15)
             .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
             .padding(.horizontal, 20)
             
             if isEdit {
                 Button {
                     withAnimation(.spring) {
                         let updateArea = [
                             "name": viewModel.productDetails.name.trim(),
                             "quantity": viewModel.productDetails.quantity.toDouble(),
                             "price": viewModel.productDetails.price.toDouble(),
                             "date": configToDate(dateConfig)
                         ]
                         viewModel.updateCompanyProduct(productId: product.id, updateArea: updateArea)
                         
                         formTitle = .none
                         openMenu = false
                         isEdit.toggle()
                         
                         dismiss()
                     }
                     
                 } label: {
                     Label("Kaydet", systemImage: "pencil.line")
                 }
                 .frame(maxWidth: .infinity)
                 .padding(.vertical, 15)
                 .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                 .padding(.horizontal, 20)
             }
             
         }
     }
 }
 */
