//
//  TextFieldType.swift
//  BlockInterpreter
//

import Foundation

enum TextFieldType: Int {
    case variableName, variableValue, condition
    
    var tag: Int {
        return self.rawValue
    }
}
