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
            .padding(.top, padding)
            .opacity(isEmpty ? 0 : 1)
            .overlay {
                if isEmpty {
                    VStack(alignment:.center) {
                        VStack() {
                            Image("notFound")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                            
                            Text("İçerik bulunamadı.")
                        }
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding()
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
        }
        .defaultScrollAnchor(isEmpty ? .center : .top, for: .alignment)
    }
}

struct Test_BaseList: View {
    @State private var isReset: Bool = false
    let tuple = example_TupleModel
    
    var body: some View {
        BaseList(isEmpty: true) {
            
            ForEach(0...10, id: \.self) { id in
                SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                    WorkCard(company: tuple.company, work: tuple.work)
                }
                actions: {
                    Action(tint: .red, icon: "trash.fill") { }
                    
                    Action(tint: .green, icon: "checkmark.square") { }
                }
                .padding(2)
                .overlay {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(lineWidth: 2)
                        .fill(Color.isSkyBlue.gradient)
                        .padding(2)
                    
                }
            }
            
        }
    }
}

#Preview {
    Test_BaseList()
}
