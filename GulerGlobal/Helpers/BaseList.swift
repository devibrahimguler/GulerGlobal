//
//  BaseList.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/19/24.
//

import SwiftUI

struct BaseList<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private let isEmpty: Bool
    private let padding: CGFloat
    private let content: () -> Content
    
    init(isEmpty: Bool, padding: CGFloat = 0, @ViewBuilder content: @escaping () -> Content) {
        self.isEmpty = isEmpty
        self.padding = padding
        self.content = content
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 10) {
                content()
            }
            .padding(10)
            .background(.background, in: .rect)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding(.top, padding)
            .opacity(isEmpty ? 0 : 1)
            .overlay {
                if isEmpty {
                    Text("İçerik bulunamadı.")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding()
                        .background(.background, in: .rect(cornerRadius: 30))
                        .padding(.top)
                }
            }
        }
        .padding([.horizontal, .top], 10)
        .background(
            colorScheme == .light
            ? Color.gray.opacity(0.15)
            : Color.white.opacity(0.15)
        )
    }
}

struct BaseListTests: View {
    @State private var isReset: Bool = false
    let tuple = example_TupleModel
    
    var body: some View {
        BaseList(isEmpty: false) {
            ForEach(0...10, id: \.self) { id in
                SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                    WorkCard(
                        companyName: tuple.company.companyName,
                        work: tuple.work,
                        isApprove: false,
                        color: .bRenk)
                }
                actions: {
                    Action(tint: .red, icon: "trash.fill") { }
                    
                    Action(tint: .green, icon: "checkmark.square") { }
                }
                .padding(2)
                .overlay {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(lineWidth: 2)
                        .fill(Color.iRenk.gradient)
                        .padding(2)
                    
                }
            }
        }
    }
}

#Preview {
    BaseListTests()
}
