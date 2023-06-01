//
//  String+Extensions.swift
//  BlockInterpreter
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        NSLocalizedString(self,
                          tableName:tableName,
                          bundle: bundle,
                          value: self,
                          comment: "")
    }
}
