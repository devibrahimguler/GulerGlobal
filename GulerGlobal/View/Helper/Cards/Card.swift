//
//  Card.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 6.02.2024.
//

import SwiftUI

struct Card: View {
    @Environment(\.colorScheme) var colorScheme
    
    var work: Work
    var isApprove: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            HStack {
                Text("company.name")
                    .lineLimit(1)
                    .font(.system(size: 17, weight: .black, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black)
                
                Spacer()
                
                Text("P-\(work.id)")
                    .lineLimit(1)
                    .font(.system(size: 11, weight: .black, design: .default))
                    .foregroundStyle(.blue)
                
                
            }
            
            HStack {
                Text("\(work.name)")
                    .lineLimit(1)
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Text("\(isApprove ? work.accept.remMoney.customDouble() : work.price.customDouble()) ₺")
                    .lineLimit(1)
                    .font(.system(size: 20, weight: .black, design: .default))
                    .foregroundStyle(isApprove ? .red : .green)
            }
        }
        .padding(10)
        .background(.hWhite)
        .clipShape(RoundedCorner(radius: 10))
        .overlay {
            RoundedCorner(radius: 10)
                .stroke(style: .init(lineWidth: 1))
                .fill(.lGray)
        }
        .shadow(color: colorScheme == .dark ? .white : .black ,radius: 2)
    }
}

struct TestCard: View {
    var body: some View {
        Card(work: Work(id: "0000", workId: "0000", name: "Sıcak Press", desc: "Sıcak press yapılacak", price: 20000, approve: "Approve", accept: Accept(remMoney: 1000, isExpiry: false, recList: [Statement(date: .now, price: 1000)], expList: [Statement(date: .now, price: 1000)], start: .now, finished: .now), product: [Product(name: "name", quantity: 10, price: 1000, suggestion: "deneme", purchased: .now, isBought: false)]), isApprove: true)
    }
}

#Preview {
    TestCard()
        .preferredColorScheme(.light)
}

