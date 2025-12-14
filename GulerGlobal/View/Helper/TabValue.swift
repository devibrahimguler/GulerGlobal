//
//  TabValue.swift
//  GulerGlobal
//
//  Created by ibrahim on 14.12.2025.
//

import Foundation

enum TabValue: String, CaseIterable {
    case Home = "GulerMetSan"
    case Bid = "Teklifler"
    case Approved = "İşler"
    case Profile = "Kullanıcı"
    case Search = "Ara"
    
    var symbolImage: String {
        switch self {
        case .Home: "house"
        case .Bid: "rectangle.stack"
        case .Approved: "checkmark.rectangle.stack.fill"
        case .Profile: "person.fill"
        case .Search: "magnifyingglass"
        }
    }
}
