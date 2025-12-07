//
//  ModelExample.swift
//  GulerGlobal
//
//  Created by ibrahim on 7.12.2025.
//

import SwiftUI

var example_Work = Work(
    id: "0000",
    companyId: "1",
    name: "Company Work",
    description: "Company Work",
    cost: 0,
    left: 0,
    status: .pending,
    startDate: .now,
    endDate: .now
)

var example_WorkList = [
    example_Work,
]

var example_Company = Company(
    id: "0",
    name: "GulerGlobal",
    address: "Burhaniye mahallesi, Ali galip sokak no: 9",
    phone: "(554) 170 16 35",
    status: .current
)

var example_TupleModel = TupleModel(
    company: example_Company,
    work: example_Work
)

var example_CompanyProduct = CompanyProduct(
    id: "0000",
    companyId: "0",
    name: "0",
    quantity: 0,
    price: 0,
    date: .now,
    oldPrices: example_OldPriceList
)

var example_CompanyProductList = [
    example_CompanyProduct,
    example_CompanyProduct,
    example_CompanyProduct,
    example_CompanyProduct,
    example_CompanyProduct,
]

var example_WorkProduct = WorkProduct(
    id: "0000",
    workId: "0",
    productId: "0",
    quantity: 0,
    date: .now
)

var example_WorkProductList = [
    example_WorkProduct,
    example_WorkProduct,
    example_WorkProduct,
    example_WorkProduct,
    example_WorkProduct,
]

var example_Statement = Statement(
    id: "1",
    companyId: "1",
    amount: 1000,
    date: .now,
    status: .input
)

var example_StatementList = [
    example_Statement,
    example_Statement,
    example_Statement,
    example_Statement,
    example_Statement
]

var example_OldPrice = OldPrice(
    price: 100,
    date: .now
)

var example_OldPriceList = [
    example_OldPrice,
    example_OldPrice,
    example_OldPrice,
    example_OldPrice,
    example_OldPrice,
    example_OldPrice,
]
