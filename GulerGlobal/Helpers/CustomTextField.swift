//
//  CustomTextField.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11.02.2024.
//

import SwiftUI

struct CustomTextField: View {
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isFocused: Bool

    var title: FormTitle
    @Binding var text: String
    @Binding var formTitle: FormTitle

    var keyboardType: UIKeyboardType = .default
    var color: Color = .isText
    var actionContent: (() -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            headerView
                .zIndex(1)
                .frame(height: 0)

            TextField("", text: $text, axis: .vertical)
                .lineLimit(nil)
                .font(.caption)
                .fontWeight(.semibold)
                .focused($isFocused)
                .padding(15)
                .keyboardType(keyboardType)
                .onChange(of: text) { _, _ in
                    handleTextChange()
                }
                .onChange(of: isFocused) { _, isFocused in
                    if isFocused { formTitle = title }
                }
                .multilineTextAlignment(.leading)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
        }
        .padding(10)
    }

    private var headerView: some View {
        HStack(spacing: 0) {
            
            Text(title.rawValue)
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                .background(formTitle == title ? .blue.opacity(0.5) : .red.opacity(0.5), in: .rect(cornerRadius: 30, style: .continuous))
            
            Spacer()

            if keyboardType == .phonePad, let action = actionContent {

                Button(action: action) {
                    Text("Seç")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                        .background(formTitle == title ? .blue.opacity(0.5) : .red.opacity(0.5), in: .rect(cornerRadius: 30, style: .continuous))
                }
            }
        }
        .padding(.horizontal, formTitle == title || !text.isEmpty ? 25 : 5)
        .offset(y:formTitle == title || !text.isEmpty ? -3 : 23)
        .animation(.easeIn, value: formTitle == title)
    }

    private func borderOverlay(for corners: UIRectCorner) -> some View {
        RoundedCorner(radius: 10, corners: corners)
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .fill(formTitle == title ? Color.accentColor.gradient : Color.isSkyBlue.gradient)
    }

    private var textFieldCorners: UIRectCorner {
        keyboardType == .phonePad ? [.bottomLeft, .bottomRight] : [.bottomLeft, .bottomRight, .topRight]
    }

    private func handleTextChange() {
        if keyboardType == .phonePad {
            text = text.formatPhoneNumber()
        }
    }
}

struct Test_CustomTextField: View {
    @State private var text: String = ""
    @State private var text2: String = ""
    @State private var formTitle: FormTitle = .workName
    var body: some View {
        VStack(spacing: 0) {
            CustomTextField(title: .workName, text: $text, formTitle: $formTitle, keyboardType: .default)
            CustomTextField(title: .companyName, text: $text2, formTitle: $formTitle, keyboardType: .default)
        }
    }
}

#Preview {
    Test_CustomTextField()
}
