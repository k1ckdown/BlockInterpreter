//
//  VariableBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class VariableBlockCellViewModel: BlockCellViewModel {
    
    var variableName: String?
    var variableValue: String?
    
    var shouldShowVariableType: Bool {
        variableType != nil
    }
    
    private(set) var variableType: VariableType?
    private(set) var variableNamePlaceHolder: String
    private(set) var variableValuePlaceholder: String
    
    init(variableType: VariableType?, style: BlockCellStyle) {
        variableValuePlaceholder = "17"
        variableNamePlaceHolder = "name"
        self.variableType = variableType
        super.init(type: .variable, style: style)
    }
    
    override func copyToWork() -> BlockCellViewModel {
        let copy = VariableBlockCellViewModel(variableType: variableType, style: .work)
        copy.variableName = variableName
        copy.variableValue = variableValue
        
        return copy
    }
    
}
