//
//  TupleModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 22.10.2025.
//

import SwiftUI

struct TupleModel: Hashable, Identifiable {
    let id: String = UUID().uuidString
    let company: Company
    let work: Work
}
