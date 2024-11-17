//
//  StatementList.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 1.10.2024.
//

import SwiftUI

struct CustomList: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isHidden: Bool = true
    
    var title: String
    var color: Color
    var type: ListType
    @Binding var isAdd: Bool
    @Binding var addType: ListType
    var list: [Any]?
    var work: Work
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 0) {
                
                Button {
                    withAnimation(.snappy) {
                        isHidden.toggle()
                    }
                } label: {
                    Image(systemName: isHidden ? "arrow.up.square" : "arrow.down.square")
                        .font(.title)
                        .foregroundStyle(isHidden ? .red : .white)
                        .shadow(color: .black ,radius: 1)
                    
                }
                .padding(5)
                .font(.system(size: 15, weight: .black, design: .monospaced))
                .background(Color.accentColor)
                
                Text(title)
                    .padding(10)
                    .font(.system(size: 15, weight: .black, design: .monospaced))
                    .frame(maxWidth: .infinity)
                    .shadow(color: .black ,radius: 1)
                
                
                Button {
                    addType = type
                    
                    withAnimation(.snappy) {
                        isAdd = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .shadow(color: .black ,radius: 1)
                    
                }
                .padding(5)
                .font(.system(size: 15, weight: .black, design: .monospaced))
                .background(Color.accentColor)
            }
            .foregroundStyle(.hWhite)
            .background(color)
            .clipShape(RoundedCorner(radius: 10))
            .overlay {
                RoundedCorner(radius: 10)
                    .stroke(style: .init(lineWidth: 3))
                    .fill(.black)
                
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            
            if (list?.count ?? 0 > 0) {
                if !isHidden {
                    if type == .recStatement || type == .expStatement {
                        if let list = list as? [Statement] {
                            ForEach(list, id: \.self) { statement in
                                CashCard(date: statement.date, price: statement.price, color: color) { isBought in
                                    viewModel.editStatement(type == .recStatement, list: list, statement: statement, work: work)
                                }
                                .frame(width: (UIScreen.main.bounds.width / 1.8))
                            }
                        }
                        
                    } else {
                        if let list = list as? [Product] {
                            ForEach(list, id: \.self) { product in
                                LazyVStack(spacing: 0){
                                    ProductCard(pro: product) { isBought in
                                        viewModel.editProduct(isBought, product: product, work: work)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                Circle()
                    .fill(color)
                    .frame(width: 20)
                    .overlay {
                        Circle()
                            .stroke(style: .init(lineWidth: 3))
                    }
            }
        }
        .foregroundStyle(.black)
    }
}

struct TestStatementList: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @State private var isAddStatement: Bool = false
    @State private var addType: ListType = .expStatement
    
    var body: some View {
        VStack {
            CustomList(
                title: "ALINAN PARA EKLE",
                color: .yellow,
                type: .expStatement,
                isAdd: $isAddStatement,
                addType: $addType,
                list: [
                    Statement(date: .now, price: 10000),
                    Statement(date: .now, price: 10000),
                    Statement(date: .now, price: 10000),
                    Statement(date: .now, price: 10000),
                    Statement(date: .now, price: 10000),
                    Statement(date: .now, price: 10000)
                ],
                work: .init(
                    id: "000",
                    companyId: "0",
                    name: "name",
                    desc: "desc",
                    price: 1000,
                    approve: "Wait",
                    accept: .init(
                        remMoney: 0,
                        recList: [
                            Statement(date: .now, price: 10000),
                            Statement(date: .now, price: 10000),
                            Statement(date: .now, price: 10000),
                            Statement(date: .now, price: 10000),
                            Statement(date: .now, price: 10000),
                            Statement(date: .now, price: 10000)
                        ],
                        expList: [
                            Statement(date: .now, price: 10000),
                            Statement(date: .now, price: 10000),
                            Statement(date: .now, price: 10000),
                            Statement(date: .now, price: 10000),
                            Statement(date: .now, price: 10000),
                            Statement(date: .now, price: 10000)
                        ],
                        start: .now,
                        finished: .now),
                    products: []))
        }
    }
}

#Preview {
    TestStatementList()
}
