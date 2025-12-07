//
//  ApprovalStatus.swift
//  GulerGlobal
//
//  Created by ibrahim on 7.12.2025.
//

import SwiftUI

enum ApprovalStatus: String, Codable {
    case approved = "approved"
    case pending = "pending"
    case rejected = "rejected"
    case finished = "finished"
}
