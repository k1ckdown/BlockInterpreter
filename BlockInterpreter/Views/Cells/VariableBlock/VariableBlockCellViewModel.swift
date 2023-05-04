//
//  VariableBlockCellViewModel.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 04.05.2023.
//

import Foundation

final class VariableBlockCellViewModel {
    
    private(set) var variableType: String
    private(set) var shouldShowVariableType: Bool
    private(set) var variableNamePlaceHolder: String
    private(set) var variableValuePlaceholder: String
    
    init(variableType: String?) {
        self.variableValuePlaceholder = "17"
        self.variableNamePlaceHolder = "name"
        self.variableType = variableType?.capitalized ?? ""
        self.shouldShowVariableType = variableType == nil ? false : true
    }
}
