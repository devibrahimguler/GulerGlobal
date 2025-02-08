//
//  String+Extensions.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 12/28/24.
//

import SwiftUI

extension String {
    func formatPhoneNumber() -> String {
        let cleanNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        let mask = "(XXX) XXX XX XX"
        
        var result = ""
        var startIndex = cleanNumber.startIndex
        let endIndex = cleanNumber.endIndex
        
        for char in mask where startIndex < endIndex {
            if char == "X" {
                result.append(cleanNumber[startIndex])
                startIndex = cleanNumber.index(after: startIndex)
            } else {
                result.append(char)
            }
        }
        
        return result
    }
    
    func toDouble() -> Double {
        let double = (self as NSString).doubleValue
        return double
    }
    
    func toInt() -> Int {
        let int = (self as NSString).integerValue
        return int
    }
}
