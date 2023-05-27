//
//  r.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 27.05.2023.
//

import Foundation

protocol Localizable {
    var tableName: String { get }
    var localized: String { get }
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var tableName: String {
        "Localizable"
    }
    
    var localized: String {
        return ""
    }
    
    func callAsFunction() -> String {
        self.localized
    }
}
