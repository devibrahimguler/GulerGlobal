//
//  StatementStatus.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 9.11.2025.
//

import SwiftUI

enum StatementStatus: String, Codable {
    case none = ""
    case input = "input"
    case output = "output"
    case debt = "debt"
    case lend = "lend"
}
