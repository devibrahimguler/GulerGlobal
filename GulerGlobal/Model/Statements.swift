//
//  Statements.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11.02.2024.
//

import Foundation

public class Statements: NSObject, NSCoding {
    
    public var statements: [Statement] = []
    
    enum Key: String {
        case statements = "statements"
    }
    
    init(statements: [Statement]) {
        self.statements = statements
    }
    
    override public init() {
        super.init()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(statements, forKey: Key.statements.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let mStatements = coder.decodeObject(forKey: Key.statements.rawValue) as! [Statement]
        
        self.init(statements: mStatements)
    }
}

public class Statement: NSObject, NSCoding {
    
    public var date: Date = .now
    public var price: String = ""
    
    enum Key: String {
        case date = "date"
        case price = "price"
    }
    
    init(date: Date, price: String) {
        self.date = date
        self.price = price
    }
    
    override public init() {
        super.init()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(date, forKey: Key.date.rawValue)
        coder.encode(price, forKey: Key.price.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let mDate = coder.decodeObject(forKey: Key.date.rawValue) as? Date
        let mPrice = coder.decodeObject(forKey: Key.price.rawValue) as? String
        
        self.init(date: mDate!, price: mPrice!)
    }
}
