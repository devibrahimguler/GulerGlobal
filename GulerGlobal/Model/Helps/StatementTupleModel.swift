//
//  StatementTupleModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 9.11.2025.
//

import SwiftUI

struct StatementTupleModel: Hashable, Identifiable {
    let id: String = UUID().uuidString
    let companyId: String
    let statement: [Statement]
}
