//
//  RoundedCorner.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.01.2025.
//

import SwiftUI

struct RoundedCorner: Shape {
    /// Köşe yarıçapı
    var radius: CGFloat = .infinity
    /// Yuvarlatılacak köşeler
    var corners: UIRectCorner = .allCorners

    /// Belirtilen köşeleri ve yarıçapı kullanarak bir yol oluşturur.
    func path(in rect: CGRect) -> Path {
        let roundedPath = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(roundedPath.cgPath)
    }
}


struct Test_RoundedCorner: View {
    var body: some View {
        RoundedCorner(radius: 100, corners: [.topLeft, .bottomRight])
            .padding()
    }
}

#Preview {
    Test_RoundedCorner()
}
