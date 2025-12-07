//
//  TupleModel.swift
//  GulerGlobal
//
//  Created by ibrahim on 7.12.2025.
//

import SwiftUI

struct TupleModel: Hashable, Identifiable {
    let id: String = UUID().uuidString
    let company: Company
    let work: Work
}
