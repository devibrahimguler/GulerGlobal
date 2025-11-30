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
    case supplier = "Tedarikçiler"
    case debt = "Borçlar"
    case soon = "Yakında!"
    
    var symbolImage: String {
        switch self {
        case .cancel: "trash.fill"
        case .finished: "text.badge.checkmark"
        case .currents: "house.lodge.fill"
        case .supplier: "list.bullet.rectangle"
        case .debt: "turkishlirasign.bank.building"
        case .soon: "hourglass"
        }
    }
    
}

enum FormTitle: String {
    case input = "Alınan Para"
    case inputDate = "Tahsilat Tarihi"
    case output = "Ödenen Para"
    case outputDate = "Ödeme Tarihi"
    case debt = "Alınan Borç"
    case debtDate = "Borç Alma Tarihi"
    case lend = "Verilen Borç"
    case lendDate = "Borç Verme Tarihi"
    
    case productName = "Ürün İsmi"
    case productQuantity = "Ürün Adedi"
    case productPrice = "Ürün Fiyatı"
    case supplier = "Tedarik Noktası"
    case productPurchased = "Tedarik Tarihi"
    
    case none = ""
    case companyName = "Firma İsmi"
    case companyAddress = "Addres"
    case companyPhone = "Telefon"
    case projeNumber = "Proje Id"
    case workName = "İş İsmi"
    case workDescription = "İş Açıklama"
    case workPrice = "İş Fiyatı"
 
 
    case expMoney = "Alınacak Para"


    case startDate = "Başlama Tarihi"
    case finishDate = "Tahmini Bitiş Tarihi"


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







