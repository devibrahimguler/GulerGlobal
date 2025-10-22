//
//  ProductEntryView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.02.2025.
//

import SwiftUI

struct ProductEntryView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var viewModel: MainViewModel
    
    @State private var activeField: FormTitle = .none
    @State private var config: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    @State private var hiddingAnimation: Bool = false
    @State var company: Company?
    @State var product: Product?
    var companyId: String?
    var workId: String?
    var isSupplier: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                if !isSupplier {
                    CompanyPickerView(
                        title: .supplier,
                        filter: .supplier,
                        formTitle: $activeField,
                        hiddingAnimation: $hiddingAnimation,
                        company: $company
                    )
                }
                
                if workId != nil {
                    if let company = company {
                        ProductPickerView(
                            supplier: company.companyName,
                            title: .productName,
                            formTitle: $activeField,
                            hiddingAnimation: $hiddingAnimation,
                            product: $product
                        )
                    }
                } else {
                    CustomTextField(title: .productName, text: $viewModel.productDetails.name, formTitle: $activeField)
                }
                
                CustomTextField(title: .productQuantity, text: $viewModel.productDetails.quantity, formTitle: $activeField, keyboardType: .numberPad)
                
                if isSupplier {
                    CustomTextField(title: .productPrice, text: $viewModel.productDetails.unitPrice, formTitle: $activeField, keyboardType: .numberPad)
                }
                
                CustomDatePicker(dateConfig: $config, title: .productPurchased, formTitle: $activeField)
                    .foregroundStyle(.isText)
                
            }
            .padding(10)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20, style: .continuous))
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background(colorScheme == .light ? Color.gray.opacity(0.2) : Color.white.opacity(0.2))
        .animation(.snappy, value: activeField)
        .onAppear {
            config = dateToConfig(viewModel.productDetails.purchased)
        }
        .onDisappear {
            viewModel.updateProductDetails(with: nil)
            activeField = .none
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Onayla") {
                    handleStatementSubmission()
                }
                .foregroundStyle(.isGreen)
                .font(.headline)
                .fontWeight(.semibold)
            }
        }
    }
    
    private func workSubmission() {
        guard !viewModel.productDetails.quantity.isEmpty,
              let workId = workId,
              let product = product,
              let company = company,
        let companyId = companyId else { return }
        
        let newProduct = Product(
            id: product.id,
            supplierId: company.id,
            supplier: company.companyName,
            productName: product.productName,
            quantity: viewModel.productDetails.quantity.toDouble(),
            unitPrice: product.unitPrice,
            oldPrices: viewModel.productDetails.oldPrices,
            purchased: configToDate(config)
        )
        let quantity = product.quantity - viewModel.productDetails.quantity.toDouble()
        let updateArea = [
            "quantity": quantity,
        ]
        
        viewModel.updateProductForCompany(companyId: company.id, productId: product.id, updateArea: updateArea)
        viewModel.createProductForWork(companyId: companyId, workId: workId, product: newProduct)
        
        dismiss()
    }
    
    private func companySubmission() {
        guard !viewModel.productDetails.name.isEmpty,
              !viewModel.productDetails.quantity.isEmpty,
              !viewModel.productDetails.unitPrice.isEmpty,
              let company = company else { return }
        
        let newProduct = Product(
            supplierId: company.id,
            supplier: company.companyName,
            productName: viewModel.productDetails.name,
            quantity: viewModel.productDetails.quantity.toDouble(),
            unitPrice: viewModel.productDetails.unitPrice.toDouble(),
            oldPrices: viewModel.productDetails.oldPrices,
            purchased: configToDate(config)
        )
        
        viewModel.createProduct(companyId: company.id, product: newProduct)
        
        dismiss()
    }
    
    private func handleStatementSubmission() {
        if workId != nil {
            workSubmission()
        } else {
            companySubmission()
        }
    }
}

struct Test_ProductEntryView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @State private var company: Company?
    var body: some View {
        ProductEntryView(workId: example_Work.id, isSupplier: false)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_ProductEntryView()
}

struct ProductPickerView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isHidden: Bool = true
    @State private var text: String = ""
    @State private var products: [Product] = []
    
    var supplier: String
    var title: FormTitle
    @Binding var formTitle: FormTitle
    @Binding var hiddingAnimation: Bool
    @Binding var product: Product?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 5){
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty, padding: 0) {
                        Text(title.rawValue)
                            .foregroundColor(.gray)
                    }
                    .disabled(isHidden)
                    .padding(10)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.init(degrees: isHidden ? 180 : 0))
                    .onTapGesture {
                        selectedCompany()
                    }
                    .padding(10)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .circular))
            }
            .foregroundStyle(Color.accentColor)
            .font(.headline)
            .padding(.bottom, 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.allProducts.filter { $0.supplier == supplier }, id: \.self) { c in
                        Text("-> \(c.productName)")
                            .padding(10)
                            .onTapGesture {
                                text = c.productName
                                product = c
                                selectedCompany()
                            }
                            .foregroundStyle(.gray)
                            .font(.headline)
                        
                        Divider()
                    }
                }
            }
            .frame(height: isHidden ? 0 : 500)
            .padding(.leading, 20)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
            .clipShape(.rect(cornerRadius: 30, style: .continuous))
        }
        .onChange(of: text) { _, newValue in
            searching(value: newValue)
        }
        .onChange(of: isHidden) { _, _ in
            if let product = product {
                self.text = product.productName
            } else {
                self.text = ""
            }
        }
        .frame(maxWidth: .infinity)
        .font(.caption)
        .fontWeight(.semibold)
        .padding(.horizontal, 5)
        .animation(.linear, value: isHidden)
    }
    
    func searching(value: String) {
        if value == "" {
            self.products = []
        } else {
            if let searchProduct = viewModel.searchProducts(by: text) {
                self.products = searchProduct.filter { $0.supplier == supplier }
            }
        }
    }
    
    private func selectedCompany() {
        if isHidden {
            formTitle = title
        } else {
            formTitle = .none
        }
        
        isHidden.toggle()
        hiddingAnimation.toggle()
    }
}
