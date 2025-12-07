//
//  CompanyStatus.swift
//  GulerGlobal
//
//  Created by ibrahim on 7.12.2025.
//

import SwiftUI

enum CompanyStatus: String, Codable, CaseIterable {
    case current = "current"
    case supplier = "supplier"
    case both = "both"
    case debt = "debt"
}
