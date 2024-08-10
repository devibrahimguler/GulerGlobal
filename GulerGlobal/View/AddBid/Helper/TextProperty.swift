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
                    .clipShape(RoundedCorner(radius: 5))
                    .overlay {
                        RoundedCorner(radius: 5)
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
                        Text("Seç".uppercased())
                            .padding(5)
                            .background(.green)
                            .foregroundStyle(.white)
                            .clipShape(RoundedCorner(radius: 5))
                            .overlay {
                                RoundedCorner(radius: 5)
                                    .stroke(style: .init(lineWidth: 3))
                                    .fill(formTitle == title ? .blue : .gray )
                            }
                    }
                }
                
            }
            .zIndex(1)
            .padding(.horizontal)
            
            if title == .workDescription {
                TextEditor(text: $text)
                    .focused($isFocused)
                    .frame(minHeight: 50)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                    .transparentScrolling()
                    .zIndex(0)
                    .padding(5)
                    .background(.hWhite)
                    .clipShape(RoundedCorner(radius: 5))
                    .overlay {
                        RoundedCorner(radius: 5)
                            .stroke(style: .init(lineWidth: 3))
                            .fill(formTitle == title ? .blue : .gray )
                    }
                    .keyboardType(keyboardType)
                    .zIndex(0)
                    .padding(.top, 15)
                    .padding(5)
                    .onChange(of: isFocused) { value in
                        if value {
                            formTitle = title
                        }
                    }
                
            } else {
                TextField("",text: $text)
                    .focused($isFocused)
                    .onChange(of: text) { _ in
                        if !text.isEmpty && keyboardType == .phonePad {
                            text = text.formatPhoneNumber()
                        }
                    }
                    .padding(10)
                    .background(.hWhite)
                    .clipShape(RoundedCorner(radius: 5))
                    .multilineTextAlignment(.leading)
                    .overlay {
                        RoundedCorner(radius: 5)
                            .stroke(style: .init(lineWidth: 3))
                            .fill(formTitle == title ? .blue : .gray )
                    }
                    .keyboardType(keyboardType)
                    .zIndex(0)
                    .padding(.top, 15)
                    .padding(5)
                    .onChange(of: isFocused) { value in
                        if value {
                            formTitle = title
                        }
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
        TextProperty(title: .workDescription, text: $text, formTitle: $formTitle, keyboardType: .numberPad)
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
