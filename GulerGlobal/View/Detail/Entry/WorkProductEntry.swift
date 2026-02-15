//
//  WorkProductEntry.swift
//  GulerGlobal
//
//  Created by ibrahim on 7.12.2025.
//

import SwiftUI

struct WorkProductEntry: View {
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
    
    @State var company: Company?
    @State var product: CompanyProduct?
    var workId: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                SupplierPickerView(
                    title: .supplier,
                    formTitle: $activeField,
                    hiddingAnimation: $hiddingAnimation,
                    company: $company
                )
                .environmentObject(viewModel)
                
                if let company = company {
                    ProductPickerView(
                        companyId: company.id,
                        title: .productName,
                        formTitle: $activeField,
                        hiddingAnimation: $hiddingAnimation,
                        product: $product
                    )
                }
                
                CustomTextField(
                    title: .productQuantity,
                    text: $viewModel.workProductVM.workProductDetails.quantity,
                    formTitle: $activeField,
                    keyboardType: .numberPad
                )
                
                CustomDatePicker(
                    dateConfig: $config,
                    title: .productPurchased,
                    formTitle: $activeField
                )
                .foregroundStyle(.isText)
                
            }
            .padding(.vertical)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle("Malzeme Ekle")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.snappy, value: activeField)
        .onAppear {
            config = viewModel.workProductVM.workProductDetails.date.dateToConfig()
        }
        .onDisappear {
            viewModel.workProductVM.updateDetails(with: nil)
            activeField = .none
        }
        .toolbar {
            CustomItem(title: "Onayla", icon: "checkmark", isClicked: isClicked) {
                submission()
            }
        }
    }
    
    private func submission() {
        guard
            !viewModel.workProductVM.workProductDetails.quantity.isEmpty,
            let product = product
        else {
            isClicked = false
            return
        }
        
        let workProduct = WorkProduct(
            workId: workId,
            productId: product.id,
            quantity: viewModel.workProductVM.workProductDetails.quantity.toDouble(),
            date: config.configToDate()
        )
        
        let quantity = product.quantity - viewModel.workProductVM.workProductDetails.quantity.toDouble()

        viewModel.companyProductVM.companyProductDetails.name = product.name
        viewModel.companyProductVM.companyProductDetails.quantity = "\(quantity)"
        viewModel.companyProductVM.companyProductDetails.price = "\(product.price)"
        
        viewModel.companyProductVM.update(productId: product.id, companyProductDetails: viewModel.companyProductVM.companyProductDetails, setLoading: viewModel.setLoading)
        viewModel.workProductVM.create(product: workProduct, setLoading: viewModel.setLoading)
        
        isClicked = false
        dismiss()
    }
}

struct Test_WorkProductEntry: View {
    @StateObject private var viewModel: MainViewModel = .init()
    var body: some View {
        WorkProductEntry(workId: example_Work.id)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_WorkProductEntry()
}
