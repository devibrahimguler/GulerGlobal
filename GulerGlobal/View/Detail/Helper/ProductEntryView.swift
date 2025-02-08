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
    
    @State private var formTitle: FormTitle = .none
    @State private var config: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    
    var tuple: TupleModel
    
    var body: some View {
        VStack {
            
            CustomTextField(title: .productName, text: $viewModel.productDetails.name, formTitle: $formTitle)
            
            CustomTextField(title: .productQuantity, text: $viewModel.productDetails.quantity, formTitle: $formTitle, keyboardType: .numberPad)
            
            CustomTextField(title: .productPrice, text: $viewModel.productDetails.unitPrice, formTitle: $formTitle, keyboardType: .numberPad)
            
            CustomTextField(title: .productSuggestion, text: $viewModel.productDetails.suggestion, formTitle: $formTitle)
            
            CustomDatePicker(dateConfig: $config, title: .productPurchased, activeTitle: $formTitle)
            
            Button("Onayla") {
                handleStatementSubmission()
            }
            .foregroundColor(.yazi)
            .font(.headline)
            .fontWeight(.semibold)
            .padding(10)
            .background(.uRenk, in: .rect(cornerRadius: 10))
        }
        .padding(10)
        .background(.background, in: .rect(cornerRadius: 20))
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(colorScheme == .light ? Color.gray.opacity(0.2) : Color.white.opacity(0.2))
        .animation(.snappy, value: formTitle)
        .onAppear {
            config = dateToConfig(viewModel.productDetails.purchased)
        }
        .onDisappear {
            viewModel.updateProductDetails(with: nil)
            formTitle = .none
        }
    }
    
    private func handleStatementSubmission() {

        guard !viewModel.productDetails.name.isEmpty, !viewModel.productDetails.quantity.isEmpty,
        !viewModel.productDetails.unitPrice.isEmpty,
        !viewModel.productDetails.suggestion.isEmpty else { return }
        
        let newProduct = Product(
            productName: viewModel.productDetails.name,
            quantity: viewModel.productDetails.quantity.toInt(),
            unitPrice: viewModel.productDetails.unitPrice.toDouble(),
            suggestion: viewModel.productDetails.suggestion,
            purchased: configToDate(config)
        )
        
        viewModel.createProduct(companyId: tuple.company.id, workId: tuple.work.id, product: newProduct)
        
        dismiss()
        
    }
}

struct Test_ProductEntryView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        ProductEntryView(tuple: example_TupleModel)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_ProductEntryView()
}
