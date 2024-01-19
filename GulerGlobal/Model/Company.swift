//
//  Company.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import Foundation
import SwiftData

@Model
final class Company {
    var id: UUID = UUID()
    var name: String
    var desc: String
    var adress: String
    var phone: String
    var work: Work

    init(name: String, desc: String, adress: String, phone: String, work: Work) {
        self.name = name
        self.desc = desc
        self.adress = adress
        self.phone = phone
        self.work = work
    }
}
