//
//  AddProduct.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 10.08.2024.
//

import SwiftUI

struct AddProduct: View {
    @EnvironmentObject var dataModel: FirebaseDataModel
    @Binding var timePicker: Date
    
    var body: some View {
        VStack{
            let isAddProduct: Bool = dataModel.proName == "" &&   dataModel.proQuantity == "" &&  dataModel.proPrice == "" &&         dataModel.proSuggestion == ""
            
            Text("ALINACAK EKLE")
            
            Divider()
            
            TextProperty(title: .productName, text: $dataModel.proName, formTitle: $dataModel.formTitle)
            
            TextProperty(title: .productQuantity, text: $dataModel.proQuantity, formTitle: $dataModel.formTitle, keyboardType: .numberPad)
            
            TextProperty(title: .productPrice, text: $dataModel.proPrice, formTitle: $dataModel.formTitle, keyboardType: .numberPad)
            
            TextProperty(title: .productSuggestion, text: $dataModel.proSuggestion, formTitle: $dataModel.formTitle)
            
            DateProperty(timePicker: $timePicker, date: $dataModel.proPurchasedDate, isPickerShower: $dataModel.isPickerShower, formTitle: $dataModel.formTitle, title: .productPurchased)
            
            Button {
                withAnimation(.snappy) {
                    let newProduct = Product(name: dataModel.proName, quantity: Int(dataModel.proQuantity) ?? 0, price: Double(dataModel.proPrice) ?? 0, suggestion: dataModel.proSuggestion, purchased: dataModel.proPurchasedDate, isBought: false)
                    
                    dataModel.productList.append(newProduct)
                    dataModel.proName = ""
                    dataModel.proQuantity = ""
                    dataModel.proPrice = ""
                    dataModel.proSuggestion = ""
                }
            } label: {
                Image(systemName: "plus.app")
            }
            .font(.system(size: 45, weight: .regular, design: .monospaced))
            .foregroundStyle(isAddProduct ? .gray : .blue)
            .disabled(isAddProduct)
            
            ForEach(dataModel.productList, id: \.self) { pro in
                ProductCard(isDetail: false, pro: pro) {
                    if let index = dataModel.productList.firstIndex(of: pro) {
                        dataModel.productList.remove(at: index)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .font(.system(size: 20, weight: .black, design: .default))
        .padding(10)
        .clipShape(RoundedCorner(radius: 5))
        .overlay {
            RoundedCorner(radius: 5)
                .stroke(style: .init(lineWidth: 3))
                .fill(.bBlue)
        }
        .padding(.top, 15)
        .padding(5)
    }
}

struct TestAddProduct: View {
    @StateObject private var coreDataModel: FirebaseDataModel = .init()
    @State private var timePicker: Date = .now
    
    var body: some View {
        AddProduct(timePicker: $timePicker)
            .environmentObject(coreDataModel)
    }
}

#Preview {
    TestAddProduct()
}
