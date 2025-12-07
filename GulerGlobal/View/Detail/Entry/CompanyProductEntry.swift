//
//  CompanyProductEntry.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.02.2025.
//

import SwiftUI
import FirebaseFirestore

struct CompanyProductEntry: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var viewModel: MainViewModel
    
    @State private var activeField: FormTitle = .none
    @State private var config: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    @State private var hiddingAnimation: Bool = false
    @State private var isClicked: Bool = false
    
    let company: Company
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                CustomTextField(title: .productName, text: $viewModel.companyProductDetails.name, formTitle: $activeField)
                
                CustomTextField(title: .productQuantity, text: $viewModel.companyProductDetails.quantity, formTitle: $activeField, keyboardType: .numberPad)
                
                CustomTextField(title: .productPrice, text: $viewModel.companyProductDetails.price, formTitle: $activeField, keyboardType: .numberPad)
                
                CustomDatePicker(dateConfig: $config, title: .productPurchased, formTitle: $activeField)
                    .foregroundStyle(.isText)
                
            }
            .padding(10)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20, style: .continuous))
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle(company.name)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.snappy, value: activeField)
        .onAppear {
            config = dateToConfig(viewModel.companyProductDetails.date)
        }
        .onDisappear {
            viewModel.updateCompanyProductDetails(with: nil)
            activeField = .none
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Onayla") {
                    withAnimation(.snappy) {
                        submission()
                    }
                }
                .foregroundStyle(.isGreen)
                .font(.headline)
                .fontWeight(.semibold)
                .disabled(isClicked)
            }
        }
    }
    
    private func submission() {
        isClicked = true
        guard !viewModel.companyProductDetails.name.isEmpty,
              !viewModel.companyProductDetails.quantity.isEmpty,
              !viewModel.companyProductDetails.price.isEmpty
        else {
            isClicked = false
            return
        }
        
        let oldPrices: [OldPrice] = [OldPrice(price: viewModel.companyProductDetails.price.toDouble(), date: .now)]
        
        let newProduct = CompanyProduct(
            companyId: company.id,
            name: viewModel.companyProductDetails.name,
            quantity: viewModel.companyProductDetails.quantity.toDouble(),
            price: viewModel.companyProductDetails.price.toDouble(),
            date: configToDate(config),
            oldPrices: oldPrices,
        )
        
        viewModel.companyProductCreate(product: newProduct)
        
        isClicked = false
        dismiss()
    }
}

struct Test_CompanyProductEntry: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        CompanyProductEntry(company: example_Company)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_CompanyProductEntry()
}

struct ProductPickerView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isHidden: Bool = true
    @State private var text: String = ""
    @State private var products: [CompanyProduct] = []
    
    var companyId: String
    var title: FormTitle
    @Binding var formTitle: FormTitle
    @Binding var hiddingAnimation: Bool
    @Binding var product: CompanyProduct?
    
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
                    ForEach(viewModel.companyProducts.filter { $0.companyId == companyId }, id: \.self) { c in
                        Text("-> \(c.name)")
                            .padding(10)
                            .onTapGesture {
                                text = c.name
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
                self.text = product.name
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
                self.products = searchProduct.filter { $0.companyId == companyId }
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
