//
//  CompanyEntryView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI
import ContactsUI

struct CompanyEntryView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isPhonePicker: Bool = false
    @State private var formTitle: FormTitle = .none
    
    @Binding var isAddCurrent: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            CustomTextField(title: .companyName, text: $viewModel.companyDetails.name, formTitle: $formTitle)

            CustomTextField(title: .companyAddress, text: $viewModel.companyDetails.address, formTitle: $formTitle)
            
            CustomTextField(title: .companyPhone, text: $viewModel.companyDetails.contactNumber, formTitle: $formTitle, keyboardType: .phonePad) {
                
                hideKeyboard()
                
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
            
            
            Button("Onayla") {
                withAnimation(.snappy) {
                    if viewModel.companyDetails.name != "" {
                        if viewModel.companyDetails.address != "" {
                            if viewModel.companyList.first(where: { $0.companyName == viewModel.companyDetails.name }) != nil {
                                viewModel.hasAlert = true
                            } else {
                                viewModel.createCompany()
                                dismiss()
                                
                            }
                        }
                    }
                }
            }
            .foregroundStyle(.yazi)
            .font(.headline)
            .fontWeight(.semibold)
            .padding(10)
            .background(.uRenk, in: .rect(cornerRadius: 10))
            .padding(5)
        }
        .padding(10)
        .background(.background, in: .rect(cornerRadius: 20))
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2))
        .fullScreenCover(isPresented: $isPhonePicker, content: {
            PhonePickerView(pickerNumber: $viewModel.companyDetails.contactNumber)
        })
        .onDisappear {
            formTitle = .none
            viewModel.isNewCompany = true
            viewModel.updateCompanyDetails(with: nil)
        }
        .alert(isPresented: $viewModel.hasAlert) {
            Alert(
                title: Text("Cari Mevcut"),
                message: Text("Bu isime aid bir cari bulunmaktadır!")
            )
        }
    }
}

struct TestAddCurrentView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @State private var isAddCurrent: Bool = false
    var body: some View {
        CompanyEntryView(isAddCurrent: $isAddCurrent)
            .environmentObject(viewModel)
    }
}

#Preview {
    TestAddCurrentView()
}
