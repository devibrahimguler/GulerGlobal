//
//  TextProperty.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11.02.2024.
//

import SwiftUI

struct TextProperty: View {
    @Environment(\.colorScheme) var scheme
    @FocusState private var isFocused: Bool
    
    var title: FormTitle
    
    @Binding var text: String
    @Binding var formTitle: FormTitle
    
    var keyboardType: UIKeyboardType = .default
    var color: Color = .bSea
    var content: (() -> ())?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            HStack(spacing: 0) {
                Text(title.rawValue)
                    .padding(5)
                    .background(.white)
                    .foregroundStyle(.gray)
                    .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                    .overlay {
                        RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                            .stroke(style: .init(lineWidth: 3))
                            .fill(formTitle == title ? .blue : .gray )
                    }
                
                if keyboardType == .phonePad {
                    Spacer(minLength: 0)
                    
                    Button {
                        if let content = content {
                            content()
                        }
                    } label: {
                        Text("SEÇ")
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .background(.green)
                            .foregroundStyle(.white)
                            .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                            .overlay {
                                RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                                    .stroke(style: .init(lineWidth: 3))
                                    .fill(formTitle == title ? .blue : .gray )
                            }
                    }
                }
                
            }
            .zIndex(1)
            .padding(.horizontal, 5)
            
            TextField("",text: $text)
                .focused($isFocused)
                .onChange(of: text) { _, _ in
                    if !text.isEmpty && keyboardType == .phonePad {
                        text = text.formatPhoneNumber()
                    }
                }
                .padding(5)
                .background(.hWhite)
                .clipShape(RoundedCorner(radius: 10, corners: keyboardType == .phonePad ? [.bottomLeft, .bottomRight] : [.bottomLeft, .bottomRight, .topRight]))
                .multilineTextAlignment(.leading)
                .overlay {
                    RoundedCorner(radius: 10, corners: keyboardType == .phonePad ? [.bottomLeft, .bottomRight] : [.bottomLeft, .bottomRight, .topRight])
                        .stroke(style: .init(lineWidth: 3))
                        .fill(formTitle == title ? .blue : .gray )
                }
                .keyboardType(keyboardType)
                .zIndex(0)
                .padding(.top, 23)
                .padding(5)
                .onChange(of: isFocused) { oldValue, newValue in
                    if newValue {
                        formTitle = title
                    }
                }
        }
        .font(.system(size: 15, weight: .black, design: .monospaced))
        .foregroundStyle(color)
    }
}

struct TestTextProperty: View {
    @State private var text: String = ""
    @State private var formTitle: FormTitle = .none
    var body: some View {
        TextProperty(title: .workName, text: $text, formTitle: $formTitle, keyboardType: .default)
    }
}

#Preview {
    TestTextProperty()
        .preferredColorScheme(.light)
}

extension String {
    func formatPhoneNumber() -> String {
        let cleanNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        let mask = "(XXX) XXX XX XX"
        
        var result = ""
        var startIndex = cleanNumber.startIndex
        let endIndex = cleanNumber.endIndex
        
        for char in mask where startIndex < endIndex {
            if char == "X" {
                result.append(cleanNumber[startIndex])
                startIndex = cleanNumber.index(after: startIndex)
            } else {
                result.append(char)
            }
        }
        
        return result
    }
    
    func toDouble() -> Double {
        let double = (self as NSString).doubleValue
        return double
    }
    
    func toInt() -> Int32 {
        let int = (self as NSString).intValue
        return int
    }
}

extension View {
    func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}
