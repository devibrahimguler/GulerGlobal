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
    @State private var company: Company?
    
    var tuple: TupleModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                SupplierPickerView(title: .companyName, activeField: $activeField, hiddingAnimation: $hiddingAnimation, company: $company)
                
                CustomTextField(title: .productName, text: $viewModel.productDetails.name, formTitle: $activeField)
                
                CustomTextField(title: .productQuantity, text: $viewModel.productDetails.quantity, formTitle: $activeField, keyboardType: .numberPad)
                
                CustomTextField(title: .productPrice, text: $viewModel.productDetails.unitPrice, formTitle: $activeField, keyboardType: .numberPad)
                
                CustomDatePicker(dateConfig: $config, title: .productPurchased, activeTitle: $activeField)
                
                Button("Onayla") {
                    handleStatementSubmission()
                }
                .foregroundColor(.isText)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(10)
                .background(.isGreen, in: .rect(cornerRadius: 10))
            }
            .padding(10)
            .background(.background, in: .rect(cornerRadius: 20))
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background(colorScheme == .light ? Color.gray.opacity(0.2) : Color.white.opacity(0.2))
        .animation(.snappy, value: activeField)
        .onAppear {
            config = dateToConfig(viewModel.productDetails.purchased)
        }
        .onDisappear {
            company = nil
            viewModel.updateProductDetails(with: nil)
            activeField = .none
        }
    }
    
    private func handleStatementSubmission() {

        guard !viewModel.productDetails.name.isEmpty, !viewModel.productDetails.quantity.isEmpty,
        !viewModel.productDetails.unitPrice.isEmpty,
        let company = company else { return }
        
        let newProduct = Product(
            productName: viewModel.productDetails.name,
            quantity: viewModel.productDetails.quantity.toInt(),
            unitPrice: viewModel.productDetails.unitPrice.toDouble(),
            supplier: company.companyName,
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

struct SupplierPickerView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isHidden: Bool = true
    @State private var text: String = ""
    @State private var companies: [Company] = []
    
    var title: FormTitle
    @Binding var activeField: FormTitle
    @Binding var hiddingAnimation: Bool
    @Binding var company: Company?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0){
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty, padding: 0) {
                        Text("Firma Girin")
                            .foregroundColor(.gray)
                    }
                    .disabled(isHidden)
                
                // Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.init(degrees: isHidden ? 180 : 0))
                    .onTapGesture {
                        selectedCompany()
                    }
            }
            .foregroundStyle(Color.accentColor)
            .font(.title3)
            .padding(10)
            
            Divider()
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(companies == [] ? viewModel.companyList.filter { $0.partnerRole == .both || $0.partnerRole == .supplier } : companies, id: \.self) { c in
                        Text("-> \(c.companyName)")
                            .padding(10)
                            .onTapGesture {
                                text = c.companyName
                                company = c
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
        }
        .onChange(of: text) { _, newValue in
            searching(value: newValue)
        }
        .onChange(of: isHidden) { _, _ in
            if let company = company {
                self.text = company.companyName
            } else {
                self.text = ""
            }
        }
        .frame(maxWidth: .infinity)
        .font(.caption)
        .fontWeight(.semibold)
        .background(Color.white)
        .clipShape(RoundedCorner(radius: 10, corners: .allCorners))
        .overlay {
            RoundedCorner(radius: 10, corners: .allCorners)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .fill(
                    activeField == title ?
                    Color.accentColor.gradient :
                        company != nil ?
                    Color.isGreen.gradient :
                        Color.isSkyBlue.gradient)
        }
        .padding(.horizontal, 5)
        .animation(.linear, value: isHidden)
    }
    
    func searching(value: String) {
        if value == "" {
            self.companies = []
        } else {
            if let searchCompany = viewModel.searchCompanies(by: text) {
                self.companies = searchCompany.filter { $0.partnerRole == .both || $0.partnerRole == .supplier }
            }
        }
    }
    
    private func selectedCompany() {
        if isHidden {
            activeField = title
        } else {
            activeField = .none
        }
        
        isHidden.toggle()
        hiddingAnimation.toggle()
    }
}
