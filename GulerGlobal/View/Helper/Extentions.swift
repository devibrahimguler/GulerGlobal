//
//  Extentions.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 10.08.2024.
//

import SwiftUI

enum ButtonType: String, CaseIterable {
    case cancel = "İptal"
    case finished = "Bitmiş"
    case currents = "Cariler"
    case debs = "Borçlar"
    case soon = "Yakında!"
    
    var symbolImage: String {
        switch self {
        case .cancel: "trash.fill"
        case .finished: "text.badge.checkmark"
        case .currents: "house.lodge.fill"
        case .debs: "list.bullet.rectangle"
        case .soon: "hourglass"
        }
    }
    
}

enum FormTitle: String {
    case none = ""
    case companyName = "Firma İsmi"
    case companyAddress = "Addres"
    case companyPhone = "Telefon"
    case projeNumber = "Proje Id"
    case workName = "İş İsmi"
    case workDescription = "İş Açıklama"
    case workPrice = "İş Fiyatı"
    case recMoney = "Alınan Para"
    case remMoney = "Kalan Para"
    case expMoney = "Alınacak Para"
    case recDate = "Tahsilat Tarihi"
    case expDate = "Vade Tarihi"
    case startDate = "Başlama Tarihi"
    case finishDate = "Tahmini Bitiş Tarihi"
    case productName = "Ürün İsmi"
    case productQuantity = "Ürün Adedi"
    case productPrice = "Ürün Fiyatı"
    case productSuggestion = "Alındığı Yer"
    case productPurchased = "Alınma Tarihi"
    case givMoney = "Bağlantı Miktarı"
    case givDate = "Bağlantı Tarihi"
}

enum ListType: String, CaseIterable {
    case none = "None"
    case work = "İş"
    case received = "Tahsilat"
    case expiry = "Vade"
    case product = "Ürün"
    
    var color: String {
        switch self {
        case .none: "trash.fill"
        case .work: "command"
        case .received: "text.badge.checkmark"
        case .expiry: "house.lodge.fill"
        case .product: "list.bullet.rectangle"
        }
    }
    
}







