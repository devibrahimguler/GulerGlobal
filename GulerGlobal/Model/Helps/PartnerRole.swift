//
//  PartnerRole.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 9.11.2025.
//

import SwiftUI

enum PartnerRole: String, Codable, CaseIterable {
    case none = "None"
    case current = "Current"
    case supplier = "Supplier"
    case both = "Both"
    case debt = "Debt"
}
