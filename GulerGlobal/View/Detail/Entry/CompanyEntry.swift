//
//  CompanyEntryView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI
import ContactsUI

struct CompanyEntry: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var viewModel: MainViewModel
    @State private var formTitle: FormTitle = .none
    @State private var isClicked: Bool = false
    
    var companyStatus: CompanyStatus
    
    var body: some View {
        VStack(spacing: 0) {
            CustomTextField(title: .companyName, text: $viewModel.companyVM.companyDetails.name, formTitle: $formTitle)
            
            CustomTextField(title: .companyAddress, text: $viewModel.companyVM.companyDetails.address, formTitle: $formTitle)
            
            CustomTextField(title: .companyPhone, text: $viewModel.companyVM.companyDetails.phone, formTitle: $formTitle, keyboardType: .phonePad) {
                
                hideKeyboard()
                
                CNContactStore().requestAccess(for: .contacts) { (_, _) in
                    Task { @MainActor in
                        viewModel.openPhonePicker()
                    }
                }
            }
        }
        .padding(.vertical)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .fullScreenCover(isPresented: $viewModel.isPhonePicker, content: {
            PhonePickerView(pickerNumber: $viewModel.companyVM.companyDetails.phone)
                .onDisappear {
                    formTitle = .none
                }
        })
        .onDisappear {
            formTitle = .none
            viewModel.companyVM.updateDetails(with: nil)
        }
        .alert(isPresented: $viewModel.hasAlert) {
            Alert(
                title: Text("Cari Mevcut"),
                message: Text("Bu isime aid bir cari bulunmaktadır!")
            )
        }
        .toolbar {
            CustomItem(title: "Onayla", icon: "checkmark", isClicked: isClicked) {
                submission()
            }
        }
    }
    
    private func submission() {
        isClicked = true
        guard
            viewModel.companyVM.companyDetails.name != "",
            viewModel.companyVM.companyDetails.address != ""
        else { return }
        
        if viewModel.companyVM.companies.first(where: { $0.name == viewModel.companyVM.companyDetails.name }) != nil {
            viewModel.hasAlert = true
            isClicked = false
        } else {
            
            let name = viewModel.companyVM.companyDetails.name.trim()
            let address = viewModel.companyVM.companyDetails.address.trim()
            let phone = viewModel.companyVM.companyDetails.phone
            
            let newCompany = Company(
                id: viewModel.companyVM.generateUniqueID(),
                name: name,
                address: address,
                phone: phone,
                status: companyStatus,
            )
            
            viewModel.companyVM.create(company: newCompany, setLoading: viewModel.setLoading)
            isClicked = false
            dismiss()
            
        }
    }
}

struct Test_CompanyEntry: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        CompanyEntry(companyStatus: .current)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_CompanyEntry()
}

