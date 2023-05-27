//
//  String+Extensions.swift
//  BlockInterpreter
//

import Foundation

extension String {
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var isLengthValid: Bool {
        count < 33
    }
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        NSLocalizedString(self,
                          tableName:tableName,
                          bundle: bundle,
                          value: self,
                          comment: "")
    }
}
