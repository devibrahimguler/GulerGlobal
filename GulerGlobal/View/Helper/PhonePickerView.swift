//
//  PhonePickerView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 29.07.2024.
//

import SwiftUI
import ContactsUI

struct PhonePickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var pickerNumber: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = context.coordinator
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        contactPicker.predicateForSelectionOfContact = NSPredicate(format: "phoneNumbers.@count == 1")
        contactPicker.predicateForSelectionOfProperty = NSPredicate(format: "key == 'phoneNumbers'")
      
        return contactPicker
        
    }
    
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {
        print("Updating the contacts controller!")
    }
    
    final class Coordinator: NSObject, CNContactPickerDelegate {
        
        let parent: PhonePickerView
        
        public init(_ parent: PhonePickerView) {
            self.parent = parent
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            // Clear the pickedNumber initially
            self.parent.pickerNumber = ""
            
            // Check if the contact has selected phone numbers
            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                handlePhoneNumber(phoneNumber)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
            
            if contactProperty.key == CNContactPhoneNumbersKey,
               let phoneNumber = contactProperty.value as? CNPhoneNumber {
                
                let phoneNumberString = phoneNumber.stringValue
                
                // You can now use phoneNumberString as needed
                handlePhoneNumber(phoneNumberString)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        private func handlePhoneNumber(_ phoneNumber: String) {
            let phoneNumberWithoutSpace = phoneNumber.replacingOccurrences(of: " ", with: "")
            
            // Check if the phone number starts with "+"
            let sanitizedPhoneNumber = phoneNumberWithoutSpace.hasPrefix("+") ? String(phoneNumberWithoutSpace.dropFirst(3)) : phoneNumberWithoutSpace.hasPrefix("0") ? String(phoneNumberWithoutSpace.dropFirst(1)) : phoneNumberWithoutSpace
            
            DispatchQueue.main.async {
                self.parent.pickerNumber = sanitizedPhoneNumber
            }
        }
    }
    
}
