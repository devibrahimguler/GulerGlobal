//
//  AddBidView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI
import ContactsUI

struct AddBidView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isPhonePicker: Bool = false
    @State private var offset = CGSize.zero
    @State private var formTitle: FormTitle = .none
    
    @Binding var isAddBid: Bool
    
    var body: some View {
        ScrollView(.vertical) {
            
            VStack(spacing: 2) {
                TextProperty(title: .companyName, text: $viewModel.companyName, formTitle: $formTitle, color: viewModel.isNewCompany ? .black : .gray)
                    .disabled(!viewModel.isNewCompany)
                    .onTapGesture {
                        if !viewModel.isNewCompany {
                            viewModel.isNewCompany = true
                        }
                    }
                
                
                if viewModel.isNewCompany {
                    if let companies = viewModel.searchCompanies( viewModel.companyName) {
                        ForEach(companies, id: \.self) { company in
                            Button {
                                withAnimation(.snappy) {
                                    viewModel.companyName = company.name
                                    viewModel.companyAddress = company.address
                                    viewModel.companyPhone = company.phone
                                    
                                    viewModel.isNewCompany = false
                                }
                            } label: {
                                HStack(spacing: 15) {
                                    Image(systemName: "storefront.fill")
                                        .font(.title2)
                                        .foregroundStyle(.gray)
                                    
                                    Text(company.name)
                                        .font(.system(size: 20, weight: .black, design: .monospaced))
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                }
                                .padding(10)
                                .background(.hWhite)
                                .clipShape(RoundedCorner(radius: 10))
                                .overlay {
                                    RoundedCorner(radius: 10)
                                        .stroke(style: .init(lineWidth: 3))
                                        .fill(.gray)
                                }
                                .padding(5)
                                
                            }
                        }
                    }
                    
                    TextProperty(title: .companyAddress, text: $viewModel.companyAddress, formTitle: $formTitle)
                }

                HStack {
                    if viewModel.isNewCompany {
                        TextProperty(title: .companyPhone, text: $viewModel.companyPhone, formTitle: $formTitle, keyboardType: .phonePad, color: .gray) {
                            CNContactStore().requestAccess(for: .contacts) { (_, _) in
                                let status = CNContactStore.authorizationStatus(for: .contacts)
                                
                                switch status {
                                case .notDetermined:
                                    print("notDetermined")
                                case .restricted:
                                    print("restricted")
                                case .denied:
                                    print("denied")
                                case .authorized:
                                    isPhonePicker = true
                                case .limited:
                                    print("limited")
                                @unknown default:
                                    print("default denied")
                                }
                                
                                
                            }
                        }
                    }
                    
                    TextProperty(title: .projeNumber, text: $viewModel.workPNum, formTitle: $formTitle, keyboardType: .numberPad, color: viewModel.isPNum ? .gray : .black)
                        .disabled(viewModel.isPNum)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                if viewModel.isPNum {
                                    viewModel.isPNum = false
                                }
                            }
                        }
                        .frame(width: 140)
                }
                
                TextProperty(title: .workName, text: $viewModel.workName, formTitle: $formTitle)
                
                TextProperty(title: .workDescription, text: $viewModel.workDesc, formTitle: $formTitle)
                
                TextProperty(title: .workPrice, text: $viewModel.workPrice, formTitle: $formTitle, keyboardType: .numberPad)
                
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 10)
            
            ConfirmationButton {
                if viewModel.companyName != "" {
                    if viewModel.companyAddress != "" {
                        if viewModel.workName != "" {
                            if viewModel.workPrice != "" {
                                
                                viewModel.workApprove = "Wait"
                             
                                if let companyId = viewModel.companies.first(where: { $0.name == viewModel.companyName })?.id {
                                    viewModel.createWork(companyId)
                                } else {
                                    viewModel.createCompany()
                                }
                                
                                isAddBid = false
                                
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isPhonePicker ){
            PhonePickerView(pickerNumber: $viewModel.companyPhone)
        }
        .onAppear {
            viewModel.workPNum = viewModel.generateProjectNumber() ?? ""
        }
        .onDisappear {
            formTitle = .none
            viewModel.isNewCompany = true
            viewModel.workChange(nil)
            viewModel.companyChange(nil)
        }

    }

}

struct TestAddBidView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @State private var isAddBid: Bool = false
    var body: some View {
        AddBidView(isAddBid: $isAddBid)
            .environmentObject(viewModel)
    }
}

#Preview {
    TestAddBidView()
}

/*
 .offset(y: dataModel.formTitle == .finishDate ? -300 :  dataModel.formTitle == .startDate ? -300 : 0)
 .overlay(alignment: .bottom) {
     CustomDatePicker()
         .offset(y: dataModel.isPickerShower ? 0 : 1000)
 }
 */

