//
//  PeelEffect.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.02.2024.
//

import SwiftUI

struct PeelEffect<Content: View>: View {
    var isApprove: Bool = false
    
    var content: Content
    var onDelete: () -> ()
    var onEdit: () -> ()
    var onSave: () -> ()?

    
    init(isApprove: Bool = false, @ViewBuilder content: @escaping () -> Content, onDelete: @escaping () -> (), onEdit: @escaping () -> (), onSave: @escaping () -> ()) {
        self.isApprove = isApprove
        self.content = content()
        self.onDelete = onDelete
        self.onEdit = onEdit
        self.onSave = onSave
    }
    
    @State private var dragProgress: CGFloat = 0
    @State private var isExpanded: Bool = false
    var body: some View {
        content
            .hidden()
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    let minX = rect.minX
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.BG)
                        .overlay(alignment: .trailing) {
                            HStack(spacing: 0) {
                                
                                if !isApprove {
                                    SwipeActionButton(dragProgress: $dragProgress, isExpanded: $isExpanded, onAction: onDelete, color: .red, icon: "trash")
                                }
                                
                                SwipeActionButton(dragProgress: $dragProgress, isExpanded: $isExpanded, onAction: onEdit, color: .yellow, icon: "square.and.pencil", isClipShape: isApprove)
                                
                                if !isApprove {
                                    SwipeActionButton(dragProgress: $dragProgress, isExpanded: $isExpanded, onAction: onSave, color: .green, icon: "checkmark.square", isClipShape: true)
                                }
                                
                            }
                        }
                        .padding(30)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    guard !isExpanded else { return }
                                    
                                    var translationX = value.translation.width
                                    translationX = max(-translationX, 0)
                                    
                                    let progress = min(1, translationX / rect.width)
                                    dragProgress = progress
                                }).onEnded({ value in
                                    guard !isExpanded else { return }
                                    
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                        if dragProgress > 0.25 {
                                            if isApprove {
                                                dragProgress = 0.3
                                            } else {
                                                dragProgress = 0.6
                                            }
                                          
                                            isExpanded = true
                                        } else {
                                            dragProgress = .zero
                                            isExpanded = false
                                        }
                                    }
                                })
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                dragProgress = .zero
                                isExpanded = false
                            }
                        }
                    
                        
                    content
                       
                        .allowsHitTesting(false)
                        .offset(x: dragProgress == 1 ? -minX : 0)
                        .offset(x:  -(dragProgress * rect.width))
                }
            }

    }
}

#Preview {
    ContentView()
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
