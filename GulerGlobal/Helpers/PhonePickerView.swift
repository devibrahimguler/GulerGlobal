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
        Coordinator(self)
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
        // Bu metot, UIViewController güncellemesi gerektiğinde çağrılır.
        // Şu an bir işlem yapılması gerekmiyor.
    }
    
    final class Coordinator: NSObject, CNContactPickerDelegate {
        private let parent: PhonePickerView
        
        init(_ parent: PhonePickerView) {
            self.parent = parent
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                sanitizeAndSetPhoneNumber(phoneNumber)
            }
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
            if contactProperty.key == CNContactPhoneNumbersKey,
               let phoneNumber = contactProperty.value as? CNPhoneNumber {
                sanitizeAndSetPhoneNumber(phoneNumber.stringValue)
            }
        }
        
        private func sanitizeAndSetPhoneNumber(_ phoneNumber: String) {
            let sanitizedNumber = phoneNumber
                .replacingOccurrences(of: " ", with: "") // Remove spaces
                .dropPrefix("+90")                      // Remove Turkish country code
                .dropPrefix("0")                        // Remove leading zero
            DispatchQueue.main.async {
                self.parent.pickerNumber = sanitizedNumber
            }
        }
    }
}

private extension String {
    /// Removes the specified prefix from the string.
    func dropPrefix(_ prefix: String) -> String {
        hasPrefix(prefix) ? String(dropFirst(prefix.count)) : self
    }
}

/*
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
             // parent.presentationMode.wrappedValue.dismiss()
             
         }
         
         func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
             
             if contactProperty.key == CNContactPhoneNumbersKey,
                let phoneNumber = contactProperty.value as? CNPhoneNumber {
                 
                 let phoneNumberString = phoneNumber.stringValue
                 
                 // You can now use phoneNumberString as needed
                 handlePhoneNumber(phoneNumberString)
             }
             // parent.presentationMode.wrappedValue.dismiss()
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

 */
