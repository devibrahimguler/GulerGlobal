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
            CustomTextField(title: .companyName, text: $viewModel.companyDetails.name, formTitle: $formTitle)
            
            CustomTextField(title: .companyAddress, text: $viewModel.companyDetails.address, formTitle: $formTitle)
            
            CustomTextField(title: .companyPhone, text: $viewModel.companyDetails.phone, formTitle: $formTitle, keyboardType: .phonePad) {
                
                hideKeyboard()
                
                CNContactStore().requestAccess(for: .contacts) { (_, _) in
                    Task { @MainActor in
                        viewModel.openPhonePicker()
                    }
                }
            }
        }
        .padding(10)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2))
        .fullScreenCover(isPresented: $viewModel.isPhonePicker, content: {
            PhonePickerView(pickerNumber: $viewModel.companyDetails.phone)
                .onDisappear {
                    formTitle = .none
                }
        })
        .onDisappear {
            formTitle = .none
            viewModel.updateCompanyDetails(with: nil)
        }
        .alert(isPresented: $viewModel.hasAlert) {
            Alert(
                title: Text("Cari Mevcut"),
                message: Text("Bu isime aid bir cari bulunmaktadır!")
            )
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
        guard
            viewModel.companyDetails.name != "",
            viewModel.companyDetails.address != ""
        else { return }
        
        if viewModel.companies.first(where: { $0.name == viewModel.companyDetails.name }) != nil {
            viewModel.hasAlert = true
            isClicked = false
        } else {
            
            let name = viewModel.companyDetails.name.trim()
            let address = viewModel.companyDetails.address.trim()
            let phone = viewModel.companyDetails.phone
            
            let newCompany = Company(
                id: viewModel.generateUniqueIDforCompany(),
                name: name,
                address: address,
                phone: phone,
                status: companyStatus,
            )
            
            viewModel.companyCreate(company: newCompany)
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

