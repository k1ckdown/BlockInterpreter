//
//  TextFieldType.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 05.05.2023.
//

import Foundation

enum TextFieldType: Int {
    case variableName, variableValue
    
    var tag: Int {
        return self.rawValue
    }
}
