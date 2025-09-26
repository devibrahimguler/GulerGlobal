//
//  View+Extensions.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 12/28/24.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        padding: CGFloat? = nil,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().padding(.leading, padding).opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func format(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func currencyString(_ value: Double, allowedDigits: Int = 0) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "tr_Tr")
        formatter.maximumFractionDigits = allowedDigits
        
        return formatter.string(from: .init(value: value)) ?? ""
    }
    
    var currencySymbol: String {
        let locale = Locale(identifier: "Tr")
        
        return locale.currencySymbol ?? ""
    }
    
    func getRect() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    @ViewBuilder
    func modifiers<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
    
    @ViewBuilder
    func viewCenter() -> some View {
        self
            .viewVerticalCenter()
            .viewHorizontalCenter()
    }
    
    @ViewBuilder
    func viewVerticalCenter() -> some View {
        VStack {
            Spacer()
            self
            Spacer()
        }
    }
    
    @ViewBuilder
    func viewHorizontalCenter() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
    
    
    
    
    
}
