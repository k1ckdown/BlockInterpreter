//
//  VariableBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class VariableBlockCellViewModel: BlockCellViewModel {
    
    private(set) var variableType: String
    private(set) var shouldShowVariableType: Bool
    private(set) var variableNamePlaceHolder: String
    private(set) var variableValuePlaceholder: String
    
    init(variableType: String?, style: BlockCellStyle) {
        variableValuePlaceholder = "17"
        variableNamePlaceHolder = "name"
        self.variableType = variableType?.capitalized ?? ""
        shouldShowVariableType = variableType == nil ? false : true
        super.init(type: .variable, style: style)
    }
    
    override func copyToWork() -> BlockCellViewModel {
        return VariableBlockCellViewModel(variableType: variableType, style: .work)
    }
}
