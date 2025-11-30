//
//  ApprovalStatus.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 22.10.2025.
//

import SwiftUI

enum ApprovalStatus: String, Codable {
    case none = ""
    case approved = "Approved"
    case pending = "Pending"
    case rejected = "Rejected"
    case finished = "Finished"
}
