//
//  AddCurrentView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI
import ContactsUI

struct AddCurrentView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isPhonePicker: Bool = false
    @State private var formTitle: FormTitle = .none
    
    @Binding var isAddCurrent: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            TextProperty(title: .companyName, text: $viewModel.companyName, formTitle: $formTitle, color: viewModel.isNewCompany ? .black : .gray)

            TextProperty(title: .companyAddress, text: $viewModel.companyAddress, formTitle: $formTitle)
            
            TextProperty(title: .companyPhone, text: $viewModel.companyPhone, formTitle: $formTitle, keyboardType: .phonePad, color: .gray) {
                
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
            
            ConfirmationButton {
                if viewModel.companyName != "" {
                    if viewModel.companyAddress != "" {
                        if viewModel.companies.first(where: { $0.name == viewModel.companyName }) != nil {
                            viewModel.hasAlert = true
                        } else {
                            viewModel.createCompany()
                            isAddCurrent = false
                        }
                    }
                }
            }
            
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 10)
        .sheet(isPresented: $isPhonePicker ){
            PhonePickerView(pickerNumber: $viewModel.companyPhone)
        }
        .onDisappear {
            formTitle = .none
            viewModel.isNewCompany = true
            viewModel.companyChange(nil)
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
        AddCurrentView(isAddCurrent: $isAddCurrent)
            .environmentObject(viewModel)
    }
}

#Preview {
    TestAddCurrentView()
}
