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
    // formTitle -> activeField
    @Binding var formTitle: FormTitle

    var keyboardType: UIKeyboardType = .default
    // color -> accentColor
    var color: Color = .isText
    var actionContent: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView

            TextField("", text: $text, axis: .vertical)
                .lineLimit(nil)
                .font(.caption)
                .fontWeight(.semibold)
                .focused($isFocused)
                .padding(10)
                .background(Color.isCream.gradient)
                .clipShape(RoundedCorner(radius: 10, corners: textFieldCorners))
                .overlay(borderOverlay(for: textFieldCorners))
                .keyboardType(keyboardType)
                .onChange(of: text) { _, _ in
                    handleTextChange()
                }
                .onChange(of: isFocused) { _, isFocused in
                    if isFocused { formTitle = title }
                }
                .multilineTextAlignment(.leading)
        }
        .padding(5)
        .foregroundStyle(color)
    }

    private var headerView: some View {
        HStack(spacing: 0) {
            Text(title.rawValue)
                .font(.callout)
                .fontWeight(.semibold)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color.white)
                .foregroundStyle(color)
                .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                .overlay(borderOverlay(for: [.topLeft, .topRight]))

            if keyboardType == .phonePad, let action = actionContent {
                Spacer()

                Button(action: action) {
                    Text("Seç")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(Color.isGreen)
                        .foregroundStyle(.white)
                        .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                        .overlay(borderOverlay(for: [.topLeft, .topRight]))
                }
            }
        }
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
    @State private var formTitle: FormTitle = .workName
    var body: some View {
        CustomTextField(title: .workName, text: $text, formTitle: $formTitle, keyboardType: .default)
    }
}

#Preview {
    Test_CustomTextField()
}
